if (estado == 0) {
    // Fechando: o círculo diminui até sumir
    raio -= velocidade;
    if (raio <= 0) {
        raio = 0;
        estado = 1;
        room_goto(sala_destino);   // tela está preta, troca de sala
    }
}
else if (estado == 1) {
    // Abrindo: o círculo cresce até mostrar tudo
    raio += velocidade;
    if (raio >= raio_max) {
        instance_destroy();        // terminou, remove a transição
    }
}