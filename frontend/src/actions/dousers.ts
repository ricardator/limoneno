import UserService from '../services/users/users.service';
import { User } from '../models/user';

// Declare the type actions constants
export const VALIDATE_USER = "VALIDATE_USER";
export const LOGGING_REQUIRED = "LOGGING_REQUIRED";
export const AUTHENTICATION_FAIL = "AUTHENTICATION_FAIL";

export const getAuthentication = (history: any) => {
  return (dispatch: any, getState: any) => {
    // Make a REST call
    UserService.getInstance().me().subscribe((data:User) => {
      // Return the user
      dispatch({
        payload: data,
        type: VALIDATE_USER
      });
    }, error => {
      history.push('/login');
    });
  }
};

export const doLogin = (email: string, password: string, history: any) => {
  return (dispatch: any, getState: any) => {
    // Make a REST call
    UserService.getInstance().login(email, password).subscribe((data:User) => {
      // Return the user
      history.push('/');
    }, error => {
      dispatch({
        type: AUTHENTICATION_FAIL
      });
    });
  }
};