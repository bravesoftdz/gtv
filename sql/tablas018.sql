INSERT INTO tcListadosGrupos
(idListadoGrupo, ListadoGrupo,bVisible)
VALUES
(3,'Proveedores',1);

INSERT INTO tcListados
(idListado, NombreListado, refGrupo, refFormulario, RutaReporte, bVisible)
VALUES
(6,'Composici�n de saldos',3,1,'composicionsaldos.lrf',1);