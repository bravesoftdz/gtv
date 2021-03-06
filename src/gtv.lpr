program gtv;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, lazreport, dbflaz, rxnew, zvdatetimectrls, zcomponent, frm_principal,
  dmconexion, dmgeneral, SD_Configuracion, versioninfo, frm_clienteam,
  dmclientes, dmediciontugs, frm_ediciontugs, frm_busquedaclientes,
  dmbuscarcliente, frm_contactosAE, frm_domicilioae, frm_equipocliente,
  dmEquipos, frm_presupuestoslistado, dmpresupuestos, frm_presupuestoae,
  frm_altamasivacuotas, frm_cuotaae, dmordenestrabajo,
  frm_ordenestrabajolistado, frm_ordentrabajoae, frm_equiposeleccion,
  frm_presupuestoseleccion, frm_conservadorae, frm_conservadoreslistado,
  frm_resptecnicoslistado, frm_resptecnicoae, frm_administradoressel,
  frm_reclamosam, dmreclamos, frm_reclamoslistado, frm_remitoslistado,
  dmremitos, frm_remitosae, frm_listadopersonal, frm_cajalistado, dmcaja,
  frm_cajaconceptoae, frm_conceptoae, frm_tugconceptoslistado, dmproveedores,
  frm_proveedoreslistado, frm_proveedoresae, frm_clientespotencialeslistado,
  dmclientespotenciales, frm_clientespotencialesae, frm_listadocheques,
  dmcheques, frm_chequesae, dmbuscarpersonaempresa,
  frm_busquedapersonasempresas, dmcompras, frm_compraslistado, frm_comprasae,
  dmplandecuentas, frm_plandecuentaslistado, frm_plandecuentasae,
  frm_ordenespagolistado, dmordenesdepago, frm_ordenpagoae, frm_cargavalores,
  dmvalores, frm_tuglocalidades, dmlocalidades, frm_localidadae,
  frm_egresosvarioslistado, dmegresosvarios, frm_egresosvariosae, frm_egresoae,
  frm_asignarpagofactura, sysutils, frm_clientecontacto, dmcompensaciones,
  frm_compensaciones, frm_configuraciones, frm_ingresoslistado, dmingresos,
  frm_ingresosae, frm_reciboslistado, dmrecibos, frm_reciboae, frm_facturaae,
  dmfacturas, frm_facturaslistado, frm_cargavaloresIngreso, frm_about,
  frm_itemfacturaae, frmseleccionargrupofacturacion, dmfacturaelectronica,
  frm_administradoresae, frm_prefacturacion, dmprefacturacion, 
frm_prefacturacionae;

{$R *.res}

begin
  Application.Title:='Gestión de Transportes Verticales';
  Application.Initialize;

  if SD_Configuracion.LeerDato(SECCION_APP,CFG_SEP_DECIMAL) = ERROR_CFG then
  begin
    SD_Configuracion.EscribirDato(SECCION_APP,CFG_SEP_DECIMAL,'.');
    SD_Configuracion.EscribirDato(SECCION_APP,CFG_SEP_MILES,',');
  end;
  SysUtils.DefaultFormatSettings.DecimalSeparator:= SD_Configuracion.LeerDato(SECCION_APP,CFG_SEP_DECIMAL)[1];
  SysUtils.DefaultFormatSettings.ThousandSeparator:= SD_Configuracion.LeerDato(SECCION_APP,CFG_SEP_MILES)[1];
  Application.CreateForm(TDM_Conexion, DM_Conexion);
  Application.CreateForm(TDM_General, DM_General);
  Application.CreateForm(TDM_Clientes, DM_Clientes);
  Application.CreateForm(TDM_EdicionTUGs, DM_EdicionTUGs);
  Application.CreateForm(TDM_BuscarCliente, DM_BuscarCliente);
  Application.CreateForm(TDM_Equipos, DM_Equipos);
  Application.CreateForm(TDM_Presupuestos, DM_Presupuestos);
  Application.CreateForm(TDM_OrdenesTrabajo, DM_OrdenesTrabajo);
  Application.CreateForm(Tdm_reclamos, dm_reclamos);
  Application.CreateForm(TDM_Remitos, DM_Remitos);
  Application.CreateForm(TDM_CAJA, DM_CAJA);
  Application.CreateForm(TDM_Proveedores, DM_Proveedores);
  Application.CreateForm(TDM_ClientesPotenciales, DM_ClientesPotenciales);
  Application.CreateForm(TDM_BuscarPersonaEmpresa, DM_BuscarPersonaEmpresa);
  Application.CreateForm(TDM_Cheques, DM_Cheques);
  Application.CreateForm(TDM_Compras, DM_Compras);
  Application.CreateForm(TDM_PlanDeCuentas, DM_PlanDeCuentas);
  Application.CreateForm(TDM_OrdenesDePago, DM_OrdenesDePago);
  Application.CreateForm(TDM_Valores, DM_Valores);
  Application.CreateForm(TDM_Localidades, DM_Localidades);
  Application.CreateForm(TDM_EgresosVarios, DM_EgresosVarios);
  Application.CreateForm(TDM_Compensaciones, DM_Compensaciones);
  Application.CreateForm(TDM_Recibos, DM_Recibos);
  Application.CreateForm(TDM_Facturas, DM_Facturas);
  Application.CreateForm(TDM_Ingresos, DM_Ingresos);
  Application.CreateForm(TDM_FacturaElectronica, DM_FacturaElectronica);
  Application.CreateForm(TDM_Prefacturacion, DM_Prefacturacion);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);

  Application.Run;
end.

