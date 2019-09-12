import * as React from 'react';
import './project.scss';
import 'antd/dist/antd.css';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { withRouter, Link } from 'react-router-dom';
import { Icon, Progress, Tooltip, Tag, Button, Modal } from 'antd';
import { User } from '../../../../models/user';
import { Dataset } from '../../../../models/dataset';
import { destroyProject, assignPool } from '../../../../actions/doprojects';
import DatasetItemMapperComponent from '../mapper/mapper';

export class ProjectComponent extends React.Component<any> {

  // Define the props in component
  props: any;

  // Define state variable
  state: any = {
    asingModal: false
  }

  showUsers(): any {
    return (
      this.props.project.users.map((user: User) => {
        return (
          <Tooltip placement="top" title={user.name} key={user.id}>
            <div className="user__portrait">
              <Icon type="user" />
            </div>
          </Tooltip>
        )
      })
    )
  }

  total(): number {
    return this.props.project.assignated + this.props.project.free_pool +
      this.props.project.free_pool_done + this.props.project.assignated_done;
  }

  done(): number {
    return this.props.project.assignated_done + this.props.project.free_pool_done;
  }

  progress(): number {
    if (this.done() > 0) {
      return Math.floor(this.done() / this.total() * 100);
    } else {
      return 0;
    }
  }

  showDatasets(): any {
    return (
      this.props.project.datasets.map((dataset: Dataset) => {
        return <Tag color="orange" key={dataset.id}>{dataset.name}</Tag>
      })
    )
  }

  delete(): void {
    let self = this;
    Modal.confirm({
      title: 'Desea eliminar este proyecto?',
      content: 'Se eliminar el proyecto y su progreso',
      onOk() {
        self.props.destroyProject(self.props.project);
      }
    })
  }

  loadElements(): void {
    this.setState({
      asingModal: true
    })
  }

  showModal(): any {
    if (this.state.asingModal) {
      return (
        <DatasetItemMapperComponent
          action={this.assignPool.bind(this)}
          close={this.closeModal.bind(this)}
          project={this.props.project}
        >
        </DatasetItemMapperComponent>
      )
    }
  }

  closeModal(): any {
    this.setState({
      asingModal: false
    })
  }

  assignPool(usersPool: {}): any {
    this.props.assignPool(this.props.project.id, usersPool)
    this.closeModal()
  }

  render() {
    return (
      <div className="project">
        <div className="project__name">
          <Tooltip placement="top" title={this.props.project.description}>
            {this.props.project.name}
          </Tooltip>
        </div>
        <div className="project__datasets">{this.showDatasets()}</div>
        <div className="project__users">{this.showUsers()}</div>
        <div className="project__progress">
          <div className="elements">
            {this.done()}/{this.total()} Completados
          </div>
          <Progress percent={this.progress()} />
        </div>
        <div className="project__actions">
          <Button className="space"
            onClick={this.loadElements.bind(this, {})}>
            <Icon type="usergroup-add" />Asignar
          </Button>
          <Link to={`/projects/${this.props.project.id}`}>
            <Button type="primary" className="space"><Icon type="edit" />
              Editar
            </Button>
          </Link>
          <Button type="danger" onClick={this.delete.bind(this)}>
            <Icon type="delete" /> Eliminar
          </Button>
        </div>
        {this.showModal()}
      </div>
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
    destroyProject,
    assignPool
  }, dispatch)
}

export default connect(mapStateToProps, matchDispatchToProps)(withRouter(ProjectComponent));