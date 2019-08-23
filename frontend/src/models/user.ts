export class User {
    public id: number;
    public name: string;
    public email: string;
    public admin: boolean;

    constructor(user: any = null) {
        this.id = user ? user.id : null;
        this.name = user ? user.name : null;
        this.email = user ? user.email : null;
        this.admin = user ? user.admin : null; 
    }
}