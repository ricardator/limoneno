import { combineReducers } from 'redux';
import usersComparationReducer from './users-reducers';

// Const used to integrate all reducers in the store.
const allReducers = combineReducers({
    user: usersComparationReducer,
    // comparationHistory: HistoryReducer
    
});

export default allReducers;
