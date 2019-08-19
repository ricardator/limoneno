import axios from 'axios';
import { Observable } from 'rxjs';

export class RestService {

    public static post<T>(): Observable<T> {
        return new Observable<T>(observe => {
            observe.next();
            observe.complete();
        });
    }

    public static get<T>(): Observable<T> {
        return new Observable<T>(observe => {
            observe.next();
            observe.complete();
        });
    }

    public static put<T>(): Observable<T> {
        return new Observable<T>(observe => {
            observe.next();
            observe.complete();
        });
    }

    public static delete<T>(): Observable<T> {
        return new Observable<T>(observe => {
            observe.next();
            observe.complete();
        });
    }

    public static patch<T>(): Observable<T> {
        return new Observable<T>(observe => {
            observe.next();
            observe.complete();
        });
    }
}