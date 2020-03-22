<template>
  <header>
    <nav>
      <router-link class="btn" to="/">
        OKR Board
      </router-link>
      <router-link class="btn" to="/projects">
        Projects
      </router-link>
      <router-link class="btn" to="/project_steps">
        Steps
      </router-link>
      <button class="btn log-out" @click="logOut">
        Log Out
      </button>
    </nav>
  </header>
</template>

<script>
  import { mapActions } from "vuex";
  import { api } from "../services.js";

  export default {
    name: "AppHeader",
    computed: {
      nome() {
        return 'teste';
      }
    },
    methods: {
      ...mapActions(["hideMessages"]),
      logOut() {
        api.deleteDefault("/users/sign_out").then(() => {
          this.$router.go();
        });
      }
    },
    watch: {
      '$route'() {
        this.hideMessages();
      }
    }
  }
</script>

<style scoped>
  nav {
    display: flex;
    justify-content: center;
    padding: 15px 20px;
    box-shadow: 0 2px 4px rgba(30, 60, 90, 0.1);
    text-align: center;
  }

  .btn {
    padding: 10px;
    display: block;
    background: #f4f7fc;
    color: black;
    margin-right: 10px;
    margin-bottom: 10px;
    border-radius: 4px;
  }

  .btn.log-out:hover {
    background: #db0f20;
    color: #fff;
  }

  a.router-link-exact-active, a:hover {
    background: #0072ff;
    color: #fff;
  }
</style>
