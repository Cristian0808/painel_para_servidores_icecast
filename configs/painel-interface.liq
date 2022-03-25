
set("server.telnet",true)
set("server.telnet.port",8888)
set("server.telnet.bind_addr","127.0.0.1")

silence = blank()

requests = request.equeue()

live = input.harbor(
  "live",
  port=8001,
  password="1ab2cd3ef4gh5",
  user="padrao"
)

source_chain = fallback(
  track_sensitive=false,
  [live, requests, silence]
)

radio = nrj(source_chain)

output.icecast(
  %mp3(
    bitrate=128,samplerate=44100,stereo=true
  ),
  fallible=true,
  host="127.0.0.1",
  port=8000,
  user="source",
  password="1ab2cd3ef4",
  mount="stream",
  name="Configuracao Padrao do Painel para o Icecast",
  radio
)
