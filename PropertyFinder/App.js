/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  Platform,
  StyleSheet,
  Text,
  View,
  NavigatorIOS,
} from 'react-native';

const instructions = Platform.select({
  ios: 'Press Cmd+R to reload,\n' +
    'Cmd+D or shake for dev menu',
  android: 'Double tap R on your keyboard to reload,\n' +
    'Shake or press menu button for dev menu',
});

import SearchPage from './SearchPage';

export default class App extends Component<{}> {  
  render() {
    return (
      <NavigatorIOS
        style={styles.container}
        initialRoute={{
          title: 'Property Finder',
          component: SearchPage,
        }}/>
    );
  }
}

// 教程中描述的有点不清楚,照着写NavigatorIOS不会出现
// component 如果写 SearchPage,不会出现,如果将class改成 App,
// 因为还没有SearchPage,会报错
// 找了一个网站 https://snack.expo.io/SJgA-ZFl-
// 添加一个class就可以了
class MyScene extends Component {
  render() {
    return (
      <View>
        <Text style={{ paddingTop: 80 }}>Hello World</Text>
      </View>
    )
  }
}

// type Props = {};
// export default class App extends Component<Props> {
//   render() {
//     // return React.createElement(Text, {style: styles.description}, "Search for houses to buy!");
//     // return <Text style={styles.description}>Search for houses to buy! (Again)</Text>;
//     return <Text style={styles.description}>Search for houses to buy!</Text>;
//   }
// }

//   // render() {
//   //   return (
//   //     <View style={styles.container}>
//   //       <Text style={styles.welcome}>
//   //         Welcome to React Native!
//   //       </Text>
//   //       <Text style={styles.instructions}>
//   //         To get started, edit App.js
//   //       </Text>
//   //       <Text style={styles.instructions}>
//   //         {instructions}
//   //       </Text>
//   //     </View>
//   //   );
//   // }
// }

const styles = StyleSheet.create({
    description: {
      fontSize: 18,
      textAlign: 'center',
      color: '#656565',
      marginTop: 65,
    },
    container: {
      flex: 1,
      // backgroundColor: '#F5FCFF',
    },
});



// const styles = StyleSheet.create({
//   container: {
//     flex: 1,
//     justifyContent: 'center',
//     alignItems: 'center',
//     backgroundColor: '#F5FCFF',
//   },
//   welcome: {
//     fontSize: 20,
//     textAlign: 'center',
//     margin: 10,
//   },
//   instructions: {
//     textAlign: 'center',
//     color: '#333333',
//     marginBottom: 5,
//   },
// });
