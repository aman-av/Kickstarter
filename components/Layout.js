import React from "react";
import { Container } from "semantic-ui-react";
import 'semantic-ui-css/semantic.min.css'
import Header from "./Header";

const Layout = (props) => {

  const styling = {
    background: 'linear-gradient(to bottom right, #7a86cd,#2c2b2b)',
    height: '100%',
    backgroundRepeat:'repeat'
  
  }
  
  return (
    <div style={styling}>
      <Container>
        <Header />
        <div style={{marginTop:'10px'}}>

        {props.children}
        </div>
      </Container>
    </div>
  );
};
export default Layout;
