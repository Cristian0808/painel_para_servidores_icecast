<?php
$recebe_musica = $_POST["caminho_musica"];
shell_exec("{ echo 'request.equeue_66600.push $recebe_musica'; sleep 1; } | telnet localhost 8888");
?>
