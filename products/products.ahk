#Requires AutoHotkey v2.0
#SingleInstance Force

materiales := [
    ["ACRI001", "120"],
    ["CHATALUMINIO001", "4000"],
    ["ARCHIVO001", "500"],
    ["CARTON001", "180"],
    ["CHATCHIERRO001", "450"],
    ["PyC01", "530"],
    ["PYC02", "95"],
    ["PLASPL01", "200"],
    ["PL02", "550"],
    ["OTROSV01", "110"],
    ["PASTA001", "550"],
    ["PETACEITE001", "180"],
    ["PETAMBAR001", "300"],
    ["PETTRANSP001", "900"],
    ["PETVERDE001", "180"],
    ["PLASTBCO", "400"],
    ["PLASTICO001", "400"],
    ["PLEGA001", "150"],
    ["PVC001", "250"],
    ["SILLPL01", "1300"],
    ["SOP031", "500"],
    ["TAPPLAS01", "400"],
    ["TETRAPACK001", "150"],
    ["VIDAMBAR001", "130"],
    ["VIDENVASE001", "130"]
]

cantidades := [
    "25.4",
    "50.99",
    "304.6",
    "277.57",
    "140.5",
    "88.13",
    "98.33",
    "24.7",
    "63.6",
    "50.03",
    "249.33",
    "67.78",
    "132.26",
    "268.07",
    "68.43",
    "69.56",
    "72.22",
    "164.72",
    "21.2",
    "23.77",
    "134.43",
    "50.75",
    "34.32",
    "150.94",
    "111.23"
]


F1::
{
    global materiales, cantidades

    Loop 25
    {
        indice := A_Index

        if (indice >= 6 && indice <= 10)
        {
            SendText materiales[indice][1]
            Sleep 1000

            Send "{Tab}"
            Sleep 100

            Send "^a"
            Sleep 150

            SendText cantidades[indice]
            Sleep 150

            Send "{Tab}"
            Sleep 150

            SendText materiales[indice][2]
            Sleep 300
        }
        else
        {
            SendText materiales[indice][1]
            Sleep 1500

            Loop 5
            {
                Send "{Tab}"
                Sleep 100
            }

            Sleep 150

            SendText cantidades[indice]
            Sleep 150

            Send "{Tab}"
            Sleep 150

            SendText materiales[indice][2]
            Sleep 300
        }

        Loop 5
        {
            Send "{Tab}"
            Sleep 100
        }

        Sleep 1000

        if (indice = 10 || indice = 24)
        {
            Send "{PgDn}"
            Sleep 100
        }
    }
}