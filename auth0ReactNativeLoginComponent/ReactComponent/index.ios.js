'use strict';

import React, {
   Text,
   View,
   NativeModules,
   NativeAppEventEmitter,
} from 'react-native';

var AuthLogin = require('./Auth0Login.js');

var styles = React.StyleSheet.create({
                                     container: {
                                     flex: 1,
                                     backgroundColor: 'white'
                                     }
                                     });

class auth0ReactNativeExample extends React.Component {
   render() {
      var succssSubscription = React.NativeAppEventEmitter.addListener(
                                                                                'Auth0LoginSuccess',
                                                                                (accessToken) => {
                                                                                console.log('ACCESS TOKEN')
                                                                                console.log('access_token: ' + accessToken.accessToken)
                                                                                console.log('id_token: ' + accessToken.idToken)
                                                                                console.log('token_type: ' + accessToken.tokeType)
                                                                                }
                                                                                );
      var failureSubscription = React.NativeAppEventEmitter.addListener(
                                                                                 'Auth0LoginFailed',
                                                                                 (error) => {
                                                                                 console.log('ACCESS FAILED')
                                                                                 console.log('error: ' + error.error)
                                                                                 }
                                                                                 );

      return <AuthLogin style={styles.container}/>;
   }
}

React.AppRegistry.registerComponent('auth0ReactNativeExample', () => auth0ReactNativeExample);
