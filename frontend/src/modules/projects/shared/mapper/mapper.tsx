import * as React from 'react';
import './mapper.scss';
import 'antd/dist/antd.css';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { withRouter } from 'react-router-dom';
import { Modal, Button, InputNumber, message } from 'antd';
import { User } from '../../../../models/user';

export class DatasetItemMapperComponent extends React.Component<any> {
  // Define the props in component
  public props: any;

  public state: any = {
    currentUserPool: {},
    currentFreePool: 0
  };

  public componentDidMount() {
    this.setState({
      currentFreePool: this.props.project.free_pool
    })
  }

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
                  min={0}
                  size="small"
                  defaultValue={0}
                  onChange={this.updateFreePool.bind(this, user.id)}
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

  public updateFreePool(userId: any, value: any): void {
    const newPool = { ...this.state.currentUserPool, [userId]: value }
    const values: number[] = Object.values(newPool)
    const sum = values.reduce((sum, x) => sum + x)
    if (this.props.project.free_pool - sum < 0) {
      message.warning("La cantidad asignada supera a la disponible");
      return;
    }
    this.setState({
      currentUserPool: newPool,
      currentFreePool: this.props.project.free_pool - sum
    });
  }

  public render() {
    return (
      <Modal
          title="Asignar Carga"
          visible={true}
          onCancel={this.close.bind(this, {})}
          footer={[
            <Button key="mapper" type="primary" onClick={this.close.bind(this, {})}>
              Asignar
            </Button>
          ]}>
        <div className="mapper">
          <div className="mapper_content">
            <div className="free_pool">
              Cantidad de Libre Disposición: {this.state.currentFreePool}
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