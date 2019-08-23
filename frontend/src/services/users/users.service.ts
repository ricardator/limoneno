import { Observable } from "rxjs";
import { User } from "../../models/user";
import { RestService } from "../rest/rest.service";

declare var localStorage: any;

export default class UserService {

    private static instance: UserService;
    private user: User | null = null;

    public static getInstance(): UserService {
        if (!UserService.instance) {
            UserService.instance = new UserService();
        }

        return UserService.instance;
    }

    public me(): Observable<User> {
        return new Observable<User>(observe => {
            RestService.get('users/me').subscribe(data => {
                this.user = new User(data);
                observe.next(this.user);
                observe.complete();
            }, error => {
                observe.error(error);
                observe.complete();
            });
        });
    }

    public login(email: string, password: string): Observable<User> {
        return new Observable<User>(observe => {
            RestService.post('users/login', {
                email: email,
                password: password
            }).subscribe(data => {
                data = data.data;
                RestService.setJWT(data.token);
                this.user = new User(data.user);
                observe.next(this.user);
                observe.complete();
            }, error => {
                observe.error(error);
                observe.complete();
            });
        });
    }

    public logout(): Observable<boolean> {
        return new Observable<boolean>(observe => {
            RestService.setJWT(null);
            observe.next(true);
        });
    }
}