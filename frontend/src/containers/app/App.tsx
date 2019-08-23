import React from 'react';
import './App.scss';
import logo from '../../assets/svg/logo.svg';
import { getAuthentication } from '../../actions/dousers';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { withRouter } from 'react-router';
import HeaderComponent from '../../shared/header/header';
import FooterComponent from '../../shared/footer/footer';

class App extends React.Component{
  // Define the props in component
  public props: any;

  public componentDidMount() {
    this.props.getAuthentication(this.props.history);
  }



  public render() {
    if (this.props.user) {
      return (
        <div className="App">
          <HeaderComponent></HeaderComponent>
          <div className="container">
            
          </div>
          <FooterComponent></FooterComponent>
        </div>
      );
    } else {
      return (
        <div className="App">
          <div className="container">
            <div className="splash">
              <img src={logo} />
            </div>
          </div>
        </div>
      );
    }
  }
}

// Configure React-redux store functions
function mapStateToProps(state: any) {
  return {
    user: state.user.data
  }
}

function matchDispatchToProps(dispatch: any) {
  return bindActionCreators({
    getAuthentication
  }, dispatch);
}

export default connect(mapStateToProps, matchDispatchToProps)(withRouter(App));