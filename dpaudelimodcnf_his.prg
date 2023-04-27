// Programa   : DPAUDELIMODCNF_HIS 
// Fecha/Hora : 23/11/2019 14:17:11
// Propósito  : Copiar en Historico Copia de Auditoria
// Creado Por :
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN()
  LOCAL cWhere,oDb:=OpenOdbc(oDp:cDsnConfig)

  DEFAULT oDp:nDiasDep:=90

  oDp:nDiasDep:=20

  cWhere:="AEM_FECHA"+GetWhere("<=",oDp:dFecha-oDp:nDiasDep)

// ? cWhere,COUNT("DPAUDELIMODCNF",cWhere),oDp:dFecha

  IF COUNT("DPAUDELIMODCNF",cWhere)=0 
     RETURN .T.
  ENDIF

  IF !EJECUTAR("DBISTABLE",oDp:cDsnConfig,"DPAUDELIMODCNF_HIS")
     EJECUTAR("DPTABLEHIS","DPAUDELIMODCNF",oDp:cDsnConfig,"_HIS",.F.)
  ENDIF

  EJECUTAR("DPTABLEHISUPDATE","DPAUDELIMODCNF","DPAUDELIMODCNF_HIS")

  cWhere:=IIF(Empty(cWhere),"1=1",cWhere)

  IF oDb:Execute(" INSERT INTO DPAUDELIMODCNF_HIS SELECT * FROM DPAUDELIMODCNF WHERE "+cWhere)
    oDb:Execute(" DELETE FROM DPAUDELIMODCNF WHERE "+cWhere)
  ENDIF

RETURN .T.
// EOF
