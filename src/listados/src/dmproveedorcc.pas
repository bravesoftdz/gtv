unit dmproveedorcc;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, rxmemds, ZMConnection
  ,dmgeneral, db, BufDataset, memds, ZDataset;

type

  { TDM_ProveedorCC }

  TDM_ProveedorCC = class(TDataModule)
    qPagos: TZQuery;
    qTotalCompras: TZQuery;
    qTotalComprasAFecha: TZQuery;
    qTotalPagos: TZQuery;
    qCompras: TZQuery;
    qTotalPagosAfecha: TZQuery;
    tbResultados: TRxMemoryData;
    tbResultadosComprobante: TStringField;
    tbResultadosFecha: TDateField;
    tbResultadosMonto: TFloatField;
    tbResultadosPagado: TFloatField;
    tbResultadosSaldo: TFloatField;
    procedure tbResultadosAfterInsert(DataSet: TDataSet);
  private
    _fechaFin: TDate;
    _fechaIni: TDate;
    _idProveedor: GUID_ID;
    function getSaldoProveedor: double;
    procedure AgregarSaldoAnterior;

    procedure CargarCompras;
    procedure CargarPagos;
    procedure CalcularSaldos;

    function ComponerFactura (ptoVenta, nro: integer): string;
  public
    property fechaIni: TDate write _fechaIni;
    property fechaFin: TDate write _fechaFin;
    property idProveedor: GUID_ID write _idProveedor;

    property SaldoProveedor:double read getSaldoProveedor;
    function SaldoAFecha (fecha: TDate): double;
    procedure FiltrarPagos;
  end;

var
  DM_ProveedorCC: TDM_ProveedorCC;

implementation
{$R *.lfm}
uses
    dateutils
  , strutils
  ;

{ TDM_ProveedorCC }

procedure TDM_ProveedorCC.tbResultadosAfterInsert(DataSet: TDataSet);
begin
 (*
  tbResultadosMonto.AsFloat:= 0;
  tbResultadosPagado.AsFloat:= 0;
  tbResultadosSaldo.asFloat:= 0;
  *)
end;

function TDM_ProveedorCC.getSaldoProveedor: double;
var
  compras, pagos: double;
begin
  DM_General.ReiniciarTabla(tbResultados);
  with qTotalCompras do
  begin
    if active then close;
    ParamByName('refProveedor').asString:= _idProveedor;
    Open;
    if RecordCount > 0 then
       compras:= FieldByName('Total').asFloat
    else
        compras:= 0;
    close;
  end;

  with qTotalPagos do
  begin
    if active then close;
    ParamByName('refProveedor').asString:= _idProveedor;
    Open;
    if RecordCount > 0 then
       pagos:= FieldByName('Pagado').asFloat
    else
        pagos:= 0;
    close;
  end;

  Result:= pagos - compras;
end;

function TDM_ProveedorCC.SaldoAFecha(fecha: TDate): double;
var
  compras, pagos: double;
begin
  with qTotalComprasAFecha do
  begin
    if active then close;
    ParamByName('refProveedor').asString:= _idProveedor;
    ParamByName('fechaIni').AsDate:= fecha;
    Open;
    if RecordCount > 0 then
       compras:= FieldByName('Total').asFloat
    else
        compras:= 0;
    close;
  end;

  with qTotalPagosAfecha do
  begin
    if active then close;
    ParamByName('refProveedor').asString:= _idProveedor;
    ParamByName('fechaIni').AsDate:= fecha;
    Open;
    if RecordCount > 0 then
       pagos:= FieldByName('Pagado').asFloat
    else
        pagos:= 0;
    close;
  end;

  Result:= pagos - compras;
end;

procedure TDM_ProveedorCC.AgregarSaldoAnterior;
var
  fechaAnterior: TDate;
begin
  fechaAnterior:= IncDay(_fechaIni, -1);;
  with tbResultados do
  begin
    Insert;
    FieldByName('Fecha').AsDateTime:= fechaAnterior;
    FieldByName('Comprobante').AsString:= 'Saldo al '+ DateToStr(fechaAnterior);
    FieldByName('Saldo').asFloat:= SaldoAFecha (fechaAnterior);
    Post;
  end;
end;

procedure TDM_ProveedorCC.CargarCompras;
begin
  with qCompras do
  begin
    if active then close;
    ParamByName('refProveedor').asString:= _idProveedor;
    ParamByName('fechaIni').AsDate:= _fechaIni;
    ParamByName('fechaFin').asDate:= _fechaFin;
    Open;
    First;
    While Not EOF do
    begin
      tbResultados.Insert;
      tbResultadosFecha.AsDateTime:= qCompras.FieldByName('Fecha').AsDateTime;
      tbResultadosComprobante.asString:= ComponerFactura(qCompras.FieldByName('NroPtoVenta').AsInteger
                                                        ,qCompras.FieldByName('NroFactura').AsInteger
                                                        );
      tbResultadosMonto.AsFloat:= qCompras.FieldByName('nTotal').AsFloat;
      Next;
    end;
  end;
end;

procedure TDM_ProveedorCC.CargarPagos;
begin
  with qPagos do
  begin
    if active then close;
    ParamByName('refProveedor').asString:= _idProveedor;
    ParamByName('fechaIni').AsDate:= _fechaIni;
    ParamByName('fechaFin').asDate:= _fechaFin;
    Open;
    First;
    While Not EOF do
    begin
      tbResultados.Insert;
      tbResultadosFecha.AsDateTime:= FieldByName('fFecha').AsDateTime;
      tbResultadosComprobante.asString:= 'Orden de Pago: ' + IntToStr (FieldByName('NumeroOrdenPago').asInteger);
      tbResultadosPagado.AsFloat:= FieldByName('Total').AsFloat;
      Next;
    end;
  end;

end;

procedure TDM_ProveedorCC.CalcularSaldos;
var
  saldoAnt: double;
begin
 with tbResultados do
 begin

   First;
   saldoAnt:= tbResultadosSaldo.AsFloat;
   While Not EOF do
   begin
     Edit;
     tbResultadosSaldo.AsFloat:= saldoAnt - tbResultadosMonto.asFloat + tbResultadosPagado.AsFloat;
     Post;
     saldoAnt:= tbResultadosSaldo.AsFloat;
     Next;
   end;
 end;
end;

function TDM_ProveedorCC.ComponerFactura(ptoVenta, nro: integer): string;
begin
 Result:= AddChar('0',IntToStr(ptoVenta),4)
               + ' - '
               + AddChar('0',IntToStr(nro),8);
end;

procedure TDM_ProveedorCC.FiltrarPagos;
begin
 tbResultados.DisableControls;

 DM_General.ReiniciarTabla(tbResultados);

 AgregarSaldoAnterior;
 CargarCompras;
 CargarPagos;
 tbResultados.First;
 tbResultados.SortOnFields('Fecha');
 CalcularSaldos;

 tbResultados.EnableControls;
end;

end.

