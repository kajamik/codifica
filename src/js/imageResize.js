class ImageMap
{
    arr = null;
    map = null;
    initialCoords = [];
    newCoords = [];

    constructor(map) {
        this.map = map;
        this.areas = map.querySelectorAll('area');

        for(var i = 0; i < this.areas.length; i++) {
            this.initialCoords[i] = this.areas[i].coords.split(',');
            this.newCoords[i] = this.areas[i].coords.split(',');
        }
    }

    resize()
    {
        var x = this.map.parentNode.querySelector('img').clientWidth / this.map.parentNode.querySelector('img').naturalWidth;
        for(var i = 0; i < this.areas.length; i++) {
            for(var j = 0; j < this.newCoords[i].length; j++) {
                this.newCoords[i][j] *= x;
            }
            this.newCoords[i].coords = this.newCoords[i].join(',');
            this.areas[i].coords = this.newCoords[i].coords;
            this.newCoords[i] = this.initialCoords[i];
        }
    }
}