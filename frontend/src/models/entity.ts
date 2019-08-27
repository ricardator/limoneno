export class Entity {
    public name: string;

    constructor(entity: any = null) {
        this.name = entity.name;
    }
}