<template>
  <div class="projects-board">
    <message-error />
    <message-success />
    <div class="projects-header">
      Projects
    </div>
    <table>
      <thead>
        <th>Name</th>
        <input type="button" class="add" @click.prevent="addProject" />
      </thead>
      <tbody>
        <tr v-for="project in projects" :key="project.id">
          <td class="name-column">
            <input type="text" v-model="project.name" :ref="project.id">
          </td>
          <td>
            <input
              type="button"
              class="btn"
              :class="{ 'btn-disabled': project.saved }"
              @click.prevent="save(project.id)"
              value="Save"
            />
          </td>
          <td>
            <input
              type="button"
              class="btn-remove"
              :class="{ 'btn-remove-disabled': !project.saved }"
              @click.prevent="remove(project.id)"
              value="x"
            />
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
  import { api } from "../services.js";
  import { mapActions } from "vuex";
  import MessageError from "../components/MessageError.vue";
  import MessageSuccess from "../components/MessageSuccess.vue";

  export default {
    name: "Projects",
    components: {
      MessageError,
      MessageSuccess
    },
    data() {
      return {
        projects: null,
        watchers: []
      }
    },
    methods: {
      ...mapActions(["setShowMessageSuccess", "setShowMessageError"]),
      getProjects() {
        api.get("projects").then(response => {
          const items = response.data.map(item => ({ ...item, saved: true }));
          this.projects = items;
          this.setProjectWatchers();
        });
      },
      addProject() {
        this.removeProjectWatchers();
        const id = new Date().getTime();
        this.projects.push({ id: id, name: '', saved: false });
        this.$setFocusByRefId(this.$refs, id);
        this.setProjectWatchers();
      },
      getProject(id) {
        return this.projects.find(project => project.id === id);
      },
      getProjectIndex(project) {
        return this.projects.indexOf(project);
      },
      removeProject(index) {
        this.removeProjectWatchers();
        this.projects.splice(index, 1);
        this.setProjectWatchers();
      },
      save(id) {
        const project = this.getProject(id);

        if (project.saved) {
          return;
        }

        return api.post("/projects/create_or_update", project).then(response => {
          if (response.data.status === "ok") {
            this.setShowMessageSuccess(true);
            project.id = response.data.id;
            project.saved = true;
          } else {

            this.setShowMessageError({ show: true, text: response.data.error });
          }
        });
      },
      remove(id) {
        const project = this.getProject(id);

        if (!project.saved) {
          return;
        }

        var result = confirm("Are you sure you want to remove?");

        if (result === true) {
          api.delete(`/projects/${id}`).then(() => {
            this.setShowMessageSuccess({ show: true, text: "Successfully removed." });
            this.removeProject(this.getProjectIndex(project));
          });
        }
      },
      setProjectWatchers() {
        this.projects.forEach((project, index) => {
          this.watchers.push(this.$watch(['projects', index, 'name'].join('.'), () => {
            project.saved = false;
          }));
        });
      },
      removeProjectWatchers() {
        this.watchers.forEach((unwatch) => {
          unwatch();
        });

        this.watchers = [];
      }
    },
    created() {
      this.getProjects();
    }
  }
</script>

<style scoped>
  .projects-board {
    display: flex;
    flex-direction: column;
    width: 1200px;
    min-height: 750px;
    padding: 15px 40px;
    margin: 20px auto;
    border: 1px solid rgba(0, 114, 255, 0.6);
    box-shadow: 4px 4px 6px rgba(30, 60, 90, 0.1);
    background-color: rgba(0, 114, 255, 0.1);
  }

  .projects-header {
    display: flex;
    flex-direction: row;
    justify-content: center;
    padding: 20px;
    background-color: rgba(0, 114, 255, 0.8);
    color: white;
    border-radius: 4px;
  }

  .add {
    position: relative;
    top: -32px;
    right: -1070px;
  }

  table {
    display: block;
    margin-top: 15px;
    padding-bottom: 5px;
    width: 100%;
    min-height: 640px;
    border: 1px solid rgba(0, 114, 255, 0.3);
  }

  thead {
    display: block;
    height: 40px;
    background-color: rgba(0, 114, 255, 0.6);
    color: white;
    padding-left: 10px;
    padding-right: 10px;
    padding-top: 5px;
    width: 100%;
  }

  td {
    text-align: left;
  }

  .name-column {
    width: 948px;
  }

  .btn {
    width: 100px;
    margin-left: 10px;
  }
</style>
