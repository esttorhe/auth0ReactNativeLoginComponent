
// Auth0Login.js

//import React, { requireNativeComponent } from 'react-native';
//
//class Auth0Login extends React.Component {
//   render() {
//      return <RCTAuth0Login />;
//   }
//}
//
//// requireNativeComponent automatically resolves this to "RCTAuth0LoginManager"
//var RCTAuth0Login = requireNativeComponent('RCTAuth0Login', Auth0Login);
//module.exports = Auth0Login;

'use strict';

var React = require('react-native');
var { requireNativeComponent } = React;

class AuthLoginView extends React.Component {
   render() {
      return <AuthLogin {...this.props} />;
   }
}

AuthLoginView.propTypes = {
   //
};

var AuthLogin = requireNativeComponent('AuthLogin', AuthLoginView);

module.exports = AuthLoginView;