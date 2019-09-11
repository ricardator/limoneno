export class Subclasification {
    public name: string;
    public tag: string;
    
    constructor(clasification: any = null) {
        this.name = clasification.name;
        this.tag = clasification.tag;
    }
}