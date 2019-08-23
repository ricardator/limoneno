import { VALIDATE_USER, LOGGING_REQUIRED, AUTHENTICATION_FAIL } from '../actions/dousers';
import { createBrowserHistory } from 'history';
export const browserHistory = createBrowserHistory();
/* Set the initial state of reducer.
    This reducer controlle:
    - The user authenticated in platform
*/
const initialState = {
    data: null,
    logging: false,
    auth_error: false
};

// Generate the reducer with the actions
export default function(state: any = initialState, action: any) {
    switch (action.type) {
        case VALIDATE_USER:
            return Object.assign({}, state, { data: action.payload });
        case LOGGING_REQUIRED:
            browserHistory.push('/login')
            return Object.assign({}, state, {});
        case AUTHENTICATION_FAIL:
            return Object.assign({}, state, { auth_error: true });
        default:
            return state;
    }
}
