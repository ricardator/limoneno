import * as React from 'react';
import './mapper.scss';
import 'antd/dist/antd.css';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { withRouter } from 'react-router-dom';
import { Modal, Button, InputNumber } from 'antd';
import { User } from '../../../../models/user';

export class DatasetItemMapperComponent extends React.Component<any> {
  // Define the props in component
  public props: any;


  public showProjectUsers(): any {
    return (
      <div className="users_list">
        <div className="users_item dark">
          <div className="users_info">Usuario</div>
          <div className="users_info">Email</div>
          <div className="users_info"> Asignar </div>
        </div>
        { this.props.project.users.map((user: User) => {
          return (
            <div className="users_item" key={user.id}>
              <div className="users_info">{user.name}</div>
              <div className="users_info">{user.email}</div>
              <div className="users_pool">
                <InputNumber
                  max={this.props.project.free_pool}
                  min={0}
                  size="small"
                ></InputNumber>
              </div>
            </div>
          )
        })}
      </div>
    );
  }

  public close(): void {
    this.props.close(this);
  }

  public render() {
    return (
      <Modal
          title="Asignar Carga"
          visible={true}
          onCancel={this.close.bind(this, {})}
          footer={[
            <Button key="ok" type="primary" onClick={this.close.bind(this, {})}>
              Ok
            </Button>
          ]}>
        <div className="mapper">
          <div className="mapper_content">
            <div className="label">
              Cantidad de Libre Disposición: {this.props.project.free_pool}
            </div>
            {this.showProjectUsers()}
          </div>
        </div>
      </Modal>
    )
  }
}

// Configure React-redux store functions
function mapStateToProps(state: any) {
  return {
  }
}

function matchDispatchToProps(dispatch: any) {
  return bindActionCreators({
  }, dispatch);
}

export default connect(mapStateToProps, matchDispatchToProps)(withRouter(DatasetItemMapperComponent));