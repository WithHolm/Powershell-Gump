ipmo .\Gump.psd1 -Force

function tes{
    tes2
    tes3
}
function tes2{
    New-GumpLog -Tag 'test2' -TmestampFormat 'local' -DefaultLogLevel 'Info'
}
function tes3{
    tes2
    New-GumpLog -Tag 'tes4' -TmestampFormat 'local' -DefaultLogLevel 'Info'
}

tes|%{
    "---"
    $_
}


