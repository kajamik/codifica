export class ImageMap
{
    arr = null;
    map = null;
    coords = [];

    constructor(map)
    {
        this.map = map;
        this.areas = map.querySelectorAll('area');
        this.oldWidth = 4036;

        for(var i = 0; i < this.areas.length; i++) {
            this.coords[i] = this.areas[i].coords.split(',');
        }
    }

    resize()
    {
        var x = this.map.parentNode.querySelector('img').clientWidth / this.map.parentNode.querySelector('img').naturalWidth;
        for(var i = 0; i < this.areas.length; i++) {
            for(var j = 0; j < this.coords[i].length; j++) {
                this.coords[i][j] *= x;
            }
            this.coords[i].coords = this.coords[i].join(',');
            this.areas[i].coords = this.coords[i].coords;
        }ì
    }
}