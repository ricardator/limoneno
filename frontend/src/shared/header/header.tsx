import * as React from 'react';
import './header.scss';
import logo from '../../assets/svg/logo.svg';

export default class HeaderComponent extends React.Component {
  public render() {
    return (
      <div className="header">
          <div className="logo">
            <img src={logo} />
          </div>
          <div className="menu">

          </div>
          <div className="logout">
            Cerrar sesión
          </div>
      </div>
    )
  }
}