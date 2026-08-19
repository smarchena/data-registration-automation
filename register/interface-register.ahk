#Requires AutoHotkey v2.0
#SingleInstance Force

; VARIABLES
    nombre_valor := []
    indice := 1
    pausado := false
    ultimoRegistro := 0

; INTERFAZ
    miGui := Gui("+Resize", "Carga de datos")
    miGui.SetFont("s10", "Segoe UI")

; CONFIGURACIÓN
    miGui.AddText("x20 y15", "FECHA")

    txtFecha := miGui.AddEdit(
        "x20 y40 w130 h30",
        "13/08/2025"
    )

    miGui.AddText("x170 y15", "MES")

    txtMes := miGui.AddEdit(
        "x170 y40 w80 h30",
        "FEB"
    )

    miGui.AddText("x270 y15", "AÑO")

    txtAnio := miGui.AddEdit(
        "x270 y40 w100 h30",
        "2025"
    )

; NOMBRES Y VALORES
    miGui.AddText("x20 y90", "NOMBRES")
    miGui.AddText("x430 y90", "VALORES")

    txtNombres := miGui.AddEdit(
        "x20 y115 w390 h400 Multi"
    )

    txtValores := miGui.AddEdit(
        "x430 y115 w150 h400 Multi"
    )

; BOTONES
    btnCargar := miGui.AddButton(
        "x20 y535 w150 h35",
        "Cargar datos"
    )

    btnLimpiar := miGui.AddButton(
        "x180 y535 w120 h35",
        "Limpiar"
    )

; CONTROLES
    btnContinuar := miGui.AddButton(
        "x20 y585 w150 h40",
        "Continuar"
    )

    btnRepetir := miGui.AddButton(
        "x180 y585 w180 h40",
        "Repetir último registro"
    )

    btnPausa := miGui.AddButton(
        "x370 y585 w170 h40",
        "Pausar"
    )

; ESTADO
    lblEstado := miGui.AddText(
        "x20 y640 w520",
        "Sin datos cargados"
    )

    lblRegistro := miGui.AddText(
        "x20 y665 w520",
        "Registro actual: 0"
    )

; EVENTOS
    btnCargar.OnEvent("Click", CargarDatos)
    btnLimpiar.OnEvent("Click", LimpiarDatos)

    btnContinuar.OnEvent("Click", ContinuarRegistro)
    btnRepetir.OnEvent("Click", RepetirUltimo)
    btnPausa.OnEvent("Click", PausarContinuar)

    miGui.Show("w620 h700")

; CARGAR DATOS
    CargarDatos(*)
        {
            global txtNombres
            global txtValores
            global nombre_valor
            global indice
            global ultimoRegistro
            global lblEstado
            global lblRegistro

            nombresTexto := txtNombres.Value
            valoresTexto := txtValores.Value

            nombres := StrSplit(
                nombresTexto,
                "`n",
                "`r"
            )

            valores := StrSplit(
                valoresTexto,
                "`n",
                "`r"
            )


            if nombres.Length != valores.Length
            {
                MsgBox(
                    "La cantidad de nombres y valores no coincide.`n`n"
                    . "Nombres: " nombres.Length "`n"
                    . "Valores: " valores.Length,
                    "Error",
                    "Iconx"
                )

                return
            }

            nombre_valor := []
            indice := 1
            ultimoRegistro := 0

            Loop nombres.Length
            {
                nombre := Trim(nombres[A_Index])
                valor := Trim(valores[A_Index])

                if nombre = "" && valor = ""
                {
                    continue
                }

                nombre_valor.Push(
                    [nombre, valor]
                )
            }

            if nombre_valor.Length = 0
            {
                MsgBox(
                    "No hay datos para cargar.",
                    "Aviso",
                    "Icon!"
                )

                return
            }

            lblEstado.Text :=
                "Registros cargados: "
                . nombre_valor.Length

            lblRegistro.Text :=
                "Registro actual: 1 de "
                . nombre_valor.Length

            MsgBox(
                "Datos cargados correctamente.`n`n"
                . "Registros: "
                . nombre_valor.Length
                . "`n`n"
                . "F1 ejecuta el registro actual.",
                "Datos cargados",
                "Iconi"
            )
        }

; LIMPIAR
    LimpiarDatos(*)
        {
            global txtNombres
            global txtValores
            global nombre_valor
            global indice
            global ultimoRegistro
            global lblEstado
            global lblRegistro

            txtNombres.Value := ""
            txtValores.Value := ""

            nombre_valor := []

            indice := 1

            ultimoRegistro := 0

            lblEstado.Text :=
                "Sin datos cargados"

            lblRegistro.Text :=
                "Registro actual: 0"
        }

; CONTINUAR
    ContinuarRegistro(*)
        {
            global indice
            global nombre_valor
            global ultimoRegistro
            global lblEstado
            global lblRegistro

            if nombre_valor.Length = 0
            {
                MsgBox("Primero debes cargar los datos.")
                return
            }

            if ultimoRegistro = 0
            {
                MsgBox("Primero debes ejecutar un registro con F1.")
                return
            }

            if indice >= nombre_valor.Length
            {
                MsgBox("Ya estás en el último registro.")
                return
            }            

            indice++

            ultimoRegistro := 0


            lblEstado.Text :=
                "Listo para ejecutar"

            lblRegistro.Text :=
                "Registro actual: "
                . indice
                . " de "
                . nombre_valor.Length
        }

; REPETIR ÚLTIMO REGISTRO
    RepetirUltimo(*)
        {
            global ultimoRegistro
            global indice        

            if ultimoRegistro = 0
            {
                MsgBox(
                    "Todavía no hay un registro ejecutado para repetir.",
                    "Aviso",
                    "Icon!"
                )
                return
            }

            ; Volver al registro que se ejecutó anteriormente
                indice := ultimoRegistro
                EjecutarRegistro()
        }

; PAUSAR / CONTINUAR
    PausarContinuar(*)
        {
            global pausado
            global btnPausa
            global lblEstado     

            pausado := !pausado

            if pausado
            {
                btnPausa.Text :=
                    "Continuar"

                lblEstado.Text :=
                    "AUTOMATIZACIÓN PAUSADA"
            }
            else
            {
                btnPausa.Text :=
                    "Pausar"

                lblEstado.Text :=
                    "AUTOMATIZACIÓN ACTIVA"
            }
        }

; COMPROBAR PAUSA
    EsperarSiPausado()
        {
            global pausado       

            while pausado
            {
                Sleep 100
            }
        }

; AUTOMATIZACIÓN
    F1::
    {
        EjecutarRegistro()
    }

; EJECUTAR REGISTRO
    EjecutarRegistro()
        {
            global indice
            global nombre_valor
            global ultimoRegistro

            global txtFecha
            global txtMes
            global txtAnio

            global lblEstado
            global lblRegistro
            
            ; COMPROBAR DATOS 
                if nombre_valor.Length = 0
                {
                    MsgBox(
                        "Primero debes cargar los datos en la interfaz.",
                        "Sin datos",
                        "Icon!"
                    )
                    return
                }

            ; COMPROBAR FINAL
                if indice > nombre_valor.Length
                {
                    MsgBox("Ya se procesaron todos los registros!!!")    
                    return
                }
            
            ; GUARDAR REGISTRO  
                ultimoRegistro := indice

                nombre :=
                    nombre_valor[indice][1]

                valor :=
                    nombre_valor[indice][2]

                fecha :=
                    txtFecha.Value

                mes :=
                    txtMes.Value

                anio :=
                    txtAnio.Value
            
            ; ESTADO
                lblEstado.Text :=
                    "Ejecutando: "
                    . nombre

                lblRegistro.Text :=
                    "Registro actual: "
                    . indice
                    . " de "
                    . nombre_valor.Length
            
            ; FECHA
                EsperarSiPausado()    
                Send fecha    
                Sleep 500    

                EsperarSiPausado()    
                Send "{Tab}"    
                Sleep 100
            
            ; MES
                EsperarSiPausado()    
                Send "^a"    
                Sleep 100    
                SendText mes    
                Sleep 100    
                Send "{Tab}"    
                Sleep 100
            
            ; AÑO     
                EsperarSiPausado()    
                Send "^a"    
                Sleep 100    
                SendText anio    
                Sleep 100    
                Send "{Tab}"    
                Sleep 100
            
            ; NOMBRE
                EsperarSiPausado()    
                Send nombre                    
                Sleep 1000   
                Click 422, 513
                Sleep 500            
            
            Loop 6                  
            {
                EsperarSiPausado()
                Send "{Tab}"
                Sleep 100
            }                  

            EsperarSiPausado()
            Send "{Enter}"
            Sleep 300              

            EsperarSiPausado()
            Send "{Down}"
            Sleep 200
            Send "{Down}"
            Sleep 200                

            EsperarSiPausado()
            Send "{Tab}"
            Sleep 100
            Send "{Tab}"
            Sleep 100
            
            ; CÓDIGO
                EsperarSiPausado()    
                SendText "51350502"
                Sleep 500    
                Send "{Tab}"
                Sleep 300
            
            Loop 5
            {
                EsperarSiPausado()
                Send "{Tab}"
                Sleep 100
            }            

            EsperarSiPausado()
            Sleep 500
            Send valor
            Sleep 250          

            Loop 6
            {
                EsperarSiPausado()
                Send "{Tab}"
                Sleep 100
            }

            Send "{PgDn}"
            Sleep 500

            Click 503, 361
            Sleep 500

            Click 354, 404, 2
            Sleep 1100            

            Send "{Enter}"
            Sleep 500

            Click 617, 410, 2
            Sleep 100
            Send "^a"
            Sleep 100
            Send "30/08/2025"           

            lblEstado.Text :=
                "Registro ejecutado: "
                . nombre
        }

