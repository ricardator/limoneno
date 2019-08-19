import * as React from 'react';
import './header.scss';

export default class HeaderComponent extends React.Component {
    public render() {
        return (
            <div className="dedication">
                <div className="quote">Made with <span className="red">❤</span> for Lemontech and <span className="white" eval-me="rabbits">🐇</span></div>
            </div>
        )
    }
}