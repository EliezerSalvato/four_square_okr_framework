<template>
  <div class="projects-board">
    <message-error />
    <message-success />
    <div class="projects-header">
      Projects
    </div>
    <div class="projects-data">
      <table>
        <thead>
          <tr>
            <th class="name-th">Name</th>
            <th class="save-th"></th>
            <th class="add-th">
              <input type="button" class="add" @click.prevent="addProject" />
            </th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="project in projects" :key="project.id">
            <td>
              <input type="text" v-model="project.name" :ref="project.id">
            </td>
            <td>
              <input
                type="button"
                class="btn save"
                :class="{ 'btn-disabled': project.saved }"
                @click.prevent="save(project.id)"
                value="Save"
              />
            </td>
            <td class="remove-column">
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
    font-weight: bold;
  }

  .projects-data {
    margin-top: 15px;
    min-height: 640px;
    border: 1px solid rgba(0, 114, 255, 0.3);
  }

  table {
    padding: 5px;
    width: 100%;
    border-spacing: 0;
  }

  thead {
    height: 40px;
    background-color: rgba(0, 114, 255, 0.6);
    color: white;
    margin-left: 10px;
    width: 100%;
    text-align: left;
  }

  th {
    padding-left: 5px;
    padding-right: 5px;
  }

  .name-th {
    width: 100%;
  }

  .save-th {
    min-width: 100px;
  }

  .add-th {
    min-width: 45px;
    text-align: right;
  }

  .remove-column {
    text-align: right;
  }
</style>
