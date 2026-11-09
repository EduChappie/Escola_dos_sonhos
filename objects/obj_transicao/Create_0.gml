persistent = true;      // sobrevive à troca de sala

velocidade   = 20;      // será sobrescrita pelo obj_menu
sala_destino = -1;      // será definida pelo obj_menu

estado = 0;             // 0 = fechando, 1 = abrindo
surf   = -1;            // superfície usada para "furar" o preto

// Raio necessário para cobrir a tela inteira (do centro até o canto)
raio_max = point_distance(0, 0, display_get_gui_width() / 2, display_get_gui_height() / 2);
raio     = raio_max;    // começa com a tela toda visível