import { combineReducers } from 'redux';
// import HistoryReducer from './reducers-history';
// import ComparationReducer from './reducers-comparation';

// Const used to integrate all reducers in the store.
const allReducers = combineReducers({
    // comparation: ComparationReducer,
    // comparationHistory: HistoryReducer
    
});

export default allReducers;
