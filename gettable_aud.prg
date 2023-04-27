// Programa   : GETTABLE_AUD
// Fecha/Hora : 10/09/2014 00:52:15
// Propósito  : Obtener Nombre de la Tabla de Auditoría
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cTable)
  LOCAL cTableAud:="DPAUDITAELIMOD"
  LOCAL cDb
  
  DEFAULT cTable:="DPUSUARIOS"

  SETDBSERVER() // Resetea la asignación de la Base de datos.

  cDb:=SQLGET("DPTABLAS","TAB_DSN","TAB_NOMBRE"+GetWhere("=",cTable))
  
  IF "."=LEFT(cDb,1)
     cTableAud:="DPAUDELIMODCNF"
  ENDIF

  IF "-"=LEFT(cDb,1)
     cTableAud:="DPAUDELIMODDIC"
  ENDIF

RETURN cTableAud
// EOF


