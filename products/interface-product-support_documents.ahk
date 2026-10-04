
#Requires AutoHotkey v2.0
#SingleInstance Force

materiales := [
    ["ACRI001", "150"],
    ["CHATALUMINIO001", "4500"],
    ["ARCHIVO001", "550"],
    ["CARTON001", "200"],    
    ["CHATCHIERRO001", "400"],
    ["PyC01", "550"],
    ["PYC02", "100"],
    ["PLASPL01", "250"],
    ["PL02", "600"],
    ["OTV01", "150"],
    ["PASTA001", "650"],
    ["PETACEITE001", "200"],
    ["PETAMBAR001", "250"],
    ["PETTRANSP001", "900"],
    ["PETVERDE001", "200"],
    ["PLASTBCO", "450"],
    ["PLASTICO001", "450"],
    ["PLEGA001", "100"],
    ["PVC001", "300"],
    ["SOP031", "550"],
    ["TAPPLAS01", "450"],
    ["TETRAPACK001", "200"],
    ["VIDAMBAR001", "150"],
    ["VIDENVASE001", "150"]
]

totalMateriales := materiales.Length

cantidades := []
detenerProceso := false
procesoActivo := false

ventana := Gui("+Resize", "Automatizador de materiales")
ventana.SetFont("s10", "Segoe UI")

ventana.AddText(
    "x20 y20 w500 Center",
    "AUTOMATIZADOR DE MATERIALES"
)

ventana.AddText(
    "x20 y60 w500",
    "Pegue las cantidades, una por línea:"
)

campoCantidades := ventana.AddEdit(
    "x20 y85 w500 h250 Multi WantReturn VScroll"
)

contador := ventana.AddText(
    "x20 y350 w500 Center",
    "Registros detectados: 0 / " totalMateriales
)

botonValidar := ventana.AddButton(
    "x20 y390 w150 h40",
    "Validar"
)

botonIniciar := ventana.AddButton(
    "x195 y390 w150 h40 Disabled",
    "Iniciar"
)

botonDetener := ventana.AddButton(
    "x370 y390 w150 h40 Disabled",
    "Detener"
)

estado := ventana.AddText(
    "x20 y450 w500 Center",
    "Estado: Esperando cantidades"
)

barraProgreso := ventana.AddProgress(
    "x20 y480 w500 h25 Range0-" totalMateriales,
    0
)

ventana.OnEvent("Close", CerrarPrograma)
ventana.OnEvent("Size", RedimensionarVentana)

botonValidar.OnEvent("Click", ValidarCantidades)
botonIniciar.OnEvent("Click", IniciarProceso)
botonDetener.OnEvent("Click", SolicitarDetencion)

campoCantidades.OnEvent("Change", ContarRegistros)

ventana.Show("w540 h530")


; ============================================================
; CONTAR REGISTROS
; ============================================================

ContarRegistros(*)
{
    global campoCantidades, contador, totalMateriales

    texto := Trim(campoCantidades.Value)

    if (texto = "")
    {
        contador.Text := "Registros detectados: 0 / " totalMateriales
        return
    }

    lineas := StrSplit(texto, "`n", "`r")
    registrosValidos := 0

    for linea in lineas
    {
        if (Trim(linea) != "")
            registrosValidos++
    }

    contador.Text := "Registros detectados: " registrosValidos " / " totalMateriales
}


; ============================================================
; VALIDAR CANTIDADES
; ============================================================

ValidarCantidades(*)
{
    global campoCantidades, cantidades
    global contador, estado, botonIniciar
    global totalMateriales

    texto := Trim(campoCantidades.Value)

    if (texto = "")
    {
        MsgBox(
            "No se encontraron cantidades.",
            "Error",
            "Icon!"
        )
        return
    }

    lineas := StrSplit(texto, "`n", "`r")
    cantidadesTemporales := []

    for linea in lineas
    {
        valor := Trim(linea)

        if (valor != "")
            cantidadesTemporales.Push(valor)
    }

    if (cantidadesTemporales.Length != totalMateriales)
    {
        MsgBox(
            "Se detectaron " cantidadesTemporales.Length " cantidades.`n`nDebes pegar exactamente " totalMateriales " cantidades.",
            "Cantidad incorrecta",
            "Icon!"
        )

        estado.Text := "Estado: Cantidad de registros incorrecta"
        botonIniciar.Enabled := false
        return
    }

    for indice, cantidad in cantidadesTemporales
    {
        cantidadNormalizada := StrReplace(cantidad, ",", ".")

        if !RegExMatch(cantidadNormalizada, "^\d+(\.\d+)?$")
        {
            MsgBox(
                "La línea " indice " contiene un valor no válido:`n`n" cantidad,
                "Cantidad inválida",
                "Icon!"
            )

            estado.Text := "Estado: Error en la línea " indice
            botonIniciar.Enabled := false
            return
        }

        cantidadesTemporales[indice] := cantidadNormalizada
    }

    cantidades := cantidadesTemporales

    contador.Text := "Registros detectados: " totalMateriales " / " totalMateriales
    estado.Text := "Estado: Cantidades validadas correctamente"
    botonIniciar.Enabled := true

    MsgBox(
        "Las " totalMateriales " cantidades son válidas.`n`nYa puedes presionar Iniciar.",
        "Validación correcta",
        "Iconi"
    )
}


; ============================================================
; INICIAR PROCESO
; ============================================================

IniciarProceso(*)
{
    global cantidades, procesoActivo, detenerProceso
    global campoCantidades, botonValidar
    global botonIniciar, botonDetener
    global estado, barraProgreso
    global totalMateriales

    if (cantidades.Length != totalMateriales)
    {
        MsgBox(
            "Primero debes validar las cantidades.",
            "Validación requerida",
            "Icon!"
        )
        return
    }

    procesoActivo := true
    detenerProceso := false

    campoCantidades.Enabled := false
    botonValidar.Enabled := false
    botonIniciar.Enabled := false
    botonDetener.Enabled := true

    barraProgreso.Value := 0

    Loop 5
    {
        if (detenerProceso)
        {
            FinalizarProceso("Proceso detenido antes de comenzar")
            return
        }

        segundosRestantes := 6 - A_Index

        estado.Text := "Estado: Comenzando en " segundosRestantes " segundos..."

        Sleep 1000
    }

    estado.Text := "Estado: Automatización iniciada"

    EjecutarAutomatizacion()
}


; ============================================================
; AUTOMATIZACIÓN
; ============================================================

EjecutarAutomatizacion()
{
    global materiales, cantidades
    global detenerProceso, estado, barraProgreso
    global totalMateriales

    Loop totalMateriales
    {
        if (detenerProceso)
        {
            FinalizarProceso("Proceso detenido en el producto " A_Index " de " totalMateriales)
            return
        }

        indice := A_Index

        estado.Text := "Estado: Procesando producto " indice " de " totalMateriales

        if (indice = 10 || indice = totalMateriales)
        {
            estado.Text := "Estado: Bajando la página..."

            Send "{PgDn}"
            Sleep 200
        }

        barraProgreso.Value := indice - 1

        Sleep 100


        ; ====================================================
        ; MATERIALES ESPECIALES: 6 AL 10
        ; ====================================================

        if (indice >= 6 && indice <= 10)
        {
            SendText materiales[indice][1]

            if !EsperarConDetencion(1500)
                return

            Send "{Tab}"

            if !EsperarConDetencion(100)
                return

            Send "^a"

            if !EsperarConDetencion(150)
                return

            SendText cantidades[indice]

            if !EsperarConDetencion(150)
                return

            Send "{Tab}"

            if !EsperarConDetencion(150)
                return

            SendText materiales[indice][2]

            ; OTROSV01 necesita un poco más de tiempo
            if (indice = 10)
            {
                if !EsperarConDetencion(500)
                    return
            }
            else
            {
                if !EsperarConDetencion(300)
                    return
            }
        }


        ; ====================================================
        ; RESTO DE MATERIALES
        ; ====================================================

        else
        {
            SendText materiales[indice][1]

            if !EsperarConDetencion(1500)
                return

            Loop 5
            {
                Send "{Tab}"

                if !EsperarConDetencion(100)
                    return
            }

            if !EsperarConDetencion(150)
                return

            SendText cantidades[indice]

            if !EsperarConDetencion(150)
                return

            Send "{Tab}"

            if !EsperarConDetencion(150)
                return

            SendText materiales[indice][2]

            if !EsperarConDetencion(300)
                return
        }


        ; ====================================================
        ; AVANZAR AL SIGUIENTE PRODUCTO
        ; ====================================================

        ; Después de OTROSV01 damos tiempo adicional
        ; antes de comenzar los Tabs finales.
        if (indice = 10)
        {
            if !EsperarConDetencion(500)
                return
        }

        Loop 5
        {
            Send "{Tab}"

            if !EsperarConDetencion(150)
                return
        }

        barraProgreso.Value := indice


        ; ====================================================
        ; IMPORTANTE:
        ; NO HAY PAGEDOWN POR AHORA
        ;
        ; Lo quitamos temporalmente para comprobar
        ; si el problema está realmente relacionado
        ; con PgDn.
        ; ====================================================

        if (indice < totalMateriales)
        {
            estado.Text := "Estado: Producto " indice " completado. Preparando el siguiente..."

            if !EsperarConDetencion(300)
                return
        }
    }

    FinalizarProceso("Proceso terminado correctamente")
}


; ============================================================
; ESPERAR PERMITIENDO DETENER
; ============================================================

EsperarConDetencion(tiempo)
{
    global detenerProceso

    tiempoTranscurrido := 0

    while (tiempoTranscurrido < tiempo)
    {
        if (detenerProceso)
        {
            FinalizarProceso("Proceso detenido por el usuario")
            return false
        }

        intervalo := Min(100, tiempo - tiempoTranscurrido)

        Sleep intervalo

        tiempoTranscurrido += intervalo
    }

    return true
}


; ============================================================
; SOLICITAR DETENCIÓN
; ============================================================

SolicitarDetencion(*)
{
    global detenerProceso, estado

    detenerProceso := true

    estado.Text := "Estado: Deteniendo proceso..."
}


; ============================================================
; FINALIZAR PROCESO
; ============================================================

FinalizarProceso(mensaje)
{
    global procesoActivo, detenerProceso
    global campoCantidades, botonValidar
    global botonIniciar, botonDetener
    global estado

    procesoActivo := false
    detenerProceso := false

    campoCantidades.Enabled := true
    botonValidar.Enabled := true
    botonIniciar.Enabled := true
    botonDetener.Enabled := false

    estado.Text := "Estado: " mensaje

    if (mensaje = "Proceso terminado correctamente")
    {     
        MsgBox(
            "Los materiales fueron procesados correctamente.",
            "Proceso terminado",
            "Iconi"
        )
    }
}


; ============================================================
; REDIMENSIONAR VENTANA
; ============================================================

RedimensionarVentana(guiObj, minMax, width, height)
{
    global campoCantidades, contador
    global botonValidar, botonIniciar, botonDetener
    global estado, barraProgreso

    if (minMax = -1)
        return

    nuevoAncho := width - 40

    if (nuevoAncho < 300)
        nuevoAncho := 300

    campoCantidades.Move(
        20,
        85,
        nuevoAncho,
        250
    )

    contador.Move(
        20,
        350,
        nuevoAncho
    )

    anchoBoton := (nuevoAncho - 50) / 3

    botonValidar.Move(
        20,
        390,
        anchoBoton,
        40
    )

    botonIniciar.Move(
        25 + anchoBoton,
        390,
        anchoBoton,
        40
    )

    botonDetener.Move(
        30 + (anchoBoton * 2),
        390,
        anchoBoton,
        40
    )

    estado.Move(
        20,
        450,
        nuevoAncho
    )

    barraProgreso.Move(
        20,
        480,
        nuevoAncho,
        25
    )
}


; ============================================================
; CERRAR PROGRAMA
; ============================================================

CerrarPrograma(*)
{
    global procesoActivo

    if (procesoActivo)
    {
        respuesta := MsgBox(
            "Hay una automatización en ejecución.`n`n¿Deseas cerrar el programa?",
            "Confirmar cierre",
            "YesNo Icon!"
        )

        if (respuesta = "No")
            return
    }

    ExitApp
}

