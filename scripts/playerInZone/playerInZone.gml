function player_esta_no_ponto(_ponto) {
    var _x1 = _ponto.x;
    var _y1 = _ponto.y;
    var _x2 = _ponto.x + _ponto.w;
    var _y2 = _ponto.y + _ponto.h;

    return point_in_rectangle(obj_player.x, obj_player.y, _x1, _y1, _x2, _y2);
}