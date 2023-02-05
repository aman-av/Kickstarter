import React, { Component } from "react";
import { Card, Button } from "semantic-ui-react";
import factory from "../ethereum/factory";
import Layout from "../components/Layout";
import { Link } from "../routes";

class CampaignIndex extends Component {
  static async getInitialProps() {
    const campaigns = await factory.methods.getDeployedCampaigns().call();

    return { campaigns };
  }
  renderCampaigns() {
    const data = this.props.campaigns;
    // console.log(data[0])
    let items = [];    
    for (let i = 0; i < data[0].length; ++i) {
    let  item={
        header: data[1][i],
        meta: data[0][i],
        description: (
          <div>
            {data[2][i]}<br />
            <Link route={`/campaigns/${ data[0][i] }`}>
              <a>View Campaign</a>
            </Link>
          </div>
        ),
        fluid: true,
        style: { overflowWrap: "break-word" }
    }
      items.push(item);
    }
    return <Card.Group items={items} />;
  }
  render() {
    return (
      <Layout>
        <div>
          <h3>Open Campaigns</h3>
          <Link route="/campaigns/new">
            <a>
              <Button
                floated="right"
                content="Create Campaign"
                icon="add circle"
                primary
              />
            </a>
          </Link>
          {this.renderCampaigns()}
        </div>
      </Layout>
    );
  }
}

export default CampaignIndex;
