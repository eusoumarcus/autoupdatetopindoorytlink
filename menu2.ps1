#Pega uma das 4 API's disponíveis
$ListaAPI=’API’,’APIREDUND2’,’APIREDUND3’,’APIREDUND4’
$API = Get-Random -InputObject $ListaAPI

#OP1 - PEGAR URL LIVE NOVA
$response = Invoke-WebRequest -Uri "https://youtube.googleapis.com/youtube/v3/search?part=id&channelId=UCP391YRAjSOdM_bwievgaZA&eventType=live&type=video&q=jovem+pan+news+live&maxResults=1&order=date&key=$($API)"

Write-Host "api escolhida foi essa: " $API

#$video = $response | ConvertFrom-Json
#$resultado = ConvertFrom-Json $response
$resultado = $response | ConvertFrom-Json

$videoatt = $resultado.items.id.videoId

if($resultado.items.id.videoId){
    $videoatt = $resultado.items.id.videoId

    Write-Host "pegou a busca 1 para jp news"
}else{

    $response = Invoke-WebRequest -Uri "https://www.googleapis.com/youtube/v3/search?part=id&channelId=UCP391YRAjSOdM_bwievgaZA&q=%22jovem+pan+ao+vivo%22&order=date&maxResults=1&type=video&eventType=live&publishedAfter=2022-09-27T16%3A23%3A39-05%3A00&key=$($API)"

    if($resultado.items.id.videoId){
        $response = Invoke-WebRequest -Uri "https://www.googleapis.com/youtube/v3/search?part=id&channelId=UCP391YRAjSOdM_bwievgaZA&q=%22jovem+pan+ao+vivo%22&order=date&maxResults=1&type=video&eventType=live&publishedAfter=2022-09-27T16%3A23%3A39-05%3A00&key=$($API)"
        $resultado = $response | ConvertFrom-Json
        $videoatt = $resultado.items.id.videoId

        Write-Host "pegou a busca 2 para jp news"
    }else{
        $response = Invoke-WebRequest -Uri "https://youtube.googleapis.com/youtube/v3/search?part=id&channelId=UCv-Nx8pSfG_LxbViMz14RWQ&q=%22jovem+pan+ao+vivo%22&order=date&maxResults=1&type=video&eventType=live&publishedAfter=2022-09-27T16%3A23%3A39-05%3A00&key=$($API)"
        $resultado = $response | ConvertFrom-Json
        
        Write-Host "pegou a busca 3 estamos de volta no youtube da jovem pan esportes"
    }
}

Start-Sleep -Seconds 1

#OP3 - LOGAR E ALTERAR NO PORTAL
$usuario = 'USUARIO@PROVEDOR.COM.BR'
$senha = 'SENHA'

$headers=@{}
$headers.Add("Content-Type", "multipart/form-data; boundary=---011000010111000001101001")
$headers.Add("Authorization", "Basic Og==")
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$cookie = New-Object System.Net.Cookie
$cookie.Name = 'PHPSESSID'
$cookie.Value = 'luds5kqcf80r633ev2etitacqh'
$cookie.Domain = 'indoor.digimediamarketing.com.br'
$session.Cookies.Add($cookie)
$response = Invoke-WebRequest -Uri 'https://indoor.digimediamarketing.com.br/login?login=ti%40unimedpalmas.com.br&senha=LW%3DtYUlB1%26zy%40' -Method POST -Headers $headers -WebSession $session
Start-Sleep -Seconds 1

if($resultado.items.id.videoId){
    Write-Host "EXISTE!! Codigo do video: " $resultado.items.id.videoId
    $codvideo = $resultado.items.id.videoId
}else{
    Write-Host "Encerrando pq não conseguiu pegar o código do video por algum motivo!"
    Break
}

if($resultado.items.id.videoId){
    $response = Invoke-WebRequest -Uri 'https://indoor.digimediamarketing.com.br/midia/editar/midia/3107802?=' -Method POST -Headers $headers -WebSession $session -ContentType 'application/x-www-form-urlencoded' -Body "PHP_SESSION_UPLOAD_PROGRESS=3107802&posttype=upload&DS_MIDIA=JOVEM%20PAN%20OK&DT_INICIO_CAMPANHA=&ID_TIPO_STREAMING=2&URL_STREAMING=https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3D$($codvideo)&DURACAO=00%3A05%3A00"
    Start-Sleep -Seconds 1

    #oncologia
    $response = Invoke-WebRequest -Uri 'https://indoor.digimediamarketing.com.br/json/updatedashboardplayersotimizado/?=' -Method POST -Headers $headers -WebSession $session -ContentType 'application/x-www-form-urlencoded' -Body 'playerId=4786'
    Write-Host "Atualizando player oncologia!"
    Start-Sleep -Seconds 1
    #retorno
    $response = Invoke-WebRequest -Uri 'https://indoor.digimediamarketing.com.br/json/updatedashboardplayersotimizado/?=' -Method POST -Headers $headers -WebSession $session -ContentType 'application/x-www-form-urlencoded' -Body 'playerId=2315'
    Write-Host "Atualizando player retorno!"
    Start-Sleep -Seconds 1
    #ceme 01
    $response = Invoke-WebRequest -Uri 'https://indoor.digimediamarketing.com.br/json/updatedashboardplayersotimizado/?=' -Method POST -Headers $headers -WebSession $session -ContentType 'application/x-www-form-urlencoded' -Body 'playerId=1133'
    Write-Host "Atualizando player ceme01!"
    Start-Sleep -Seconds 1
    #ceme 02
    $response = Invoke-WebRequest -Uri 'https://indoor.digimediamarketing.com.br/json/updatedashboardplayersotimizado/?=' -Method POST -Headers $headers -WebSession $session -ContentType 'application/x-www-form-urlencoded' -Body 'playerId=1283'
    Write-Host "Atualizando player ceme02!"
    Start-Sleep -Seconds 1
    #recep int
    $response = Invoke-WebRequest -Uri 'https://indoor.digimediamarketing.com.br/json/updatedashboardplayersotimizado/?=' -Method POST -Headers $headers -WebSession $session -ContentType 'application/x-www-form-urlencoded' -Body 'playerId=78'
    Write-Host "Atualizando player internação!"
    Start-Sleep -Seconds 1
    #ps
    $response = Invoke-WebRequest -Uri 'https://indoor.digimediamarketing.com.br/json/updatedashboardplayersotimizado/?=' -Method POST -Headers $headers -WebSession $session -ContentType 'application/x-www-form-urlencoded' -Body 'playerId=75'
    Write-Host "Atualizando player PS!"
    Start-Sleep -Seconds 1
}else{
    Write-Host "O RESULTADO DA BUSCA TÁ VAZIA! NADA FOI ALTERADO!"
    Write-Host "Repetindo a execução em 5min"
    Start-Sleep -Seconds 300
    PowerShell.exe -ExecutionPolicy Bypass -File C:\menu2.ps1
}

Write-Host "Script executado!"
$output = $codvideo
$output  > C:\intel\OUTPUT.txt | type C:\intel\OUTPUT.txt
Break
