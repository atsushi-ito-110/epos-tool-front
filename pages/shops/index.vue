<template>
  <div class="shops_index">
    <section class="section">
      <div class="columns">
        <div class="column is-9">
          <h1 class="title">店舗情報</h1>
        </div>
        <div class="column is-3 file_upload">
          <label for="csv_file">
            <a class="icon is-large fa-lg has-text-link" data-balloon="size: 3x">
              <font-awesome-icon :icon="['fas', 'folder-plus']" />
            </a>
            <input
              type="file"
              id="csv_file"
              style="display:none;"
              accept="text/csv"
              @change="upload($event)"
            />
          </label>
        </div>
      </div>
    </section>
    <section class="">
      <div class="shops_tree">
        <table class="table">
          <thead>
            <tr>
              <th>ID</th>
              <th>店舗名</th>
              <th>カテゴリ</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(shop, index) in shops" :key="index">
              <td> {{ shop.id }} </td>
              <td> {{ shop.name }} </td>
              <td> {{ shop.category_id }} </td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>
  </div>
</template>

<script>
export default {
  data () {
    return {
      shops: [],
      form: {
        csv: null
      }
    }
  },
  async fetch () {
    console.log('fetch')
    if (this.shops.length === 0) {
      await this.fetchShops()
    }
  },
  fetchOnServer: false,

  methods: {
    upload (event) {
      if (event.target.files[0] === undefined) {
        return
      }
      console.log(event.target.files[0])
      this.form.csv = event.target.files[0]
      const formData = new FormData
      formData.append('file', this.form.csv)
      // TODO: store化
      this.$axios.post('api/shops/import',
        formData,
        {
          headers: {
            'Content-Type': 'multipart/form-data'
          }
        }).then(response => {
          console.log(response.data)
          this.fetchShops()
        }).catch(error => {
          console.log(error);
        })
    },
    async fetchShops () {
      this.$axios.get('api/shops/')
        .then((response) => {
          console.log(response)
          this.shops = response.data.shops
        }).catch((error) => {
          console.log(error)
        })
    },
  }
}
</script>

<style lang="scss" scoped>
.shops_index {
  .shops_tree {
    padding-left: 10px;
  }
}
</style>
