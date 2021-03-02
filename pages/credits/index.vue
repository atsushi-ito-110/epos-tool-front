<template>
  <div class="credits_index">
    <section class="section">
      <div class="columns">
        <div class="column is-9">
          <h1 class="title">クレジット情報</h1>
          <h2 class="subtitle">
            エポスカードの毎月のデータを閲覧できます
          </h2>
        </div>
        <div class="column is-3 file_upload">
          <label for="csv_file">
            <a class="icon is-large fa-lg has-text-link" data-balloon="size: 3x">
              <font-awesome-icon :icon="['fas', 'folder-plus']" />
            </a>
            <input type="file" id="csv_file" style="display:none;" accept="text/csv" @change="upload($event)">
          </label>
          {{ activedMonth }}
        </div>
      </div>
    </section>
    <section class="">
      <div class="tabs">
        <ul>
          <li
            v-for="(item, index) in yearMonths"
            :key="index"
            :class="{ 'is-active': activedTab(item.yearMonth) }"
            :data-id="index"
          >
            <nuxt-link :to="`/credits?year_month=${item.yearMonth}`" >{{ item.yearMonth }}</nuxt-link>
          </li>
        </ul>
      </div>
      <div class="credit_tree">
        <div v-if="activedMonth === '2021-02' && $fetchState.pending === false">
          <p>金額: {{ totalAmount }}</p>
          <ul class="tree pl_10">
            <li v-for="(row, index) in credit.credit_details" :key="index">
              <ul class="pl_10">
                <li>
                  {{ row.billing_date }} {{ row.name }} {{ row.amount }}
                </li>
              </ul>
            </li>
          </ul>
        </div>
      </div>
    </section>
  </div>
</template>

<script>
export default {
  data () {
    return {
      yearMonths: [
        { yearMonth: '2021-02' },
        { yearMonth: '2021-01' },
        { yearMonth: '2020-12' }
      ],
      activedMonth: '2021-02',
      showables: [
        { showabled: false },
        { showabled: false },
        { showabled: false },
      ],
      form: {
        csv: '',
        billingDate: '2021-02-01'
      },
      credit: {
        credit_details: []
      }
    }
  },

  async fetch () {
    // TODO: fetchState.pendingで画面のくるくる実装したい
    if (this.$route.query.year_month) {
      this.activedMonth = this.$route.query.year_month
    }
    await this.$axios.get('http://localhost/api/credits/' + this.activedMonth, {
    }).then((response) => {
      console.log(response)
      this.credit = response.data.credit
    }).catch((error) => {
      console.log(error)
    })
  },
  fetchOnServer: false,

  // watchQuery(newQuery, oldQuery) {
  //   this.activedMonth = newQuery.year_month
  //   console.log(this.activedMonth)
  //   this.$refetch()
  //   // this.$axios.get('http://localhost/api/credits/show', {
  //   //   year_month: this.yearMonth
  //   // }).then((response) => {
  //   //   console.log(response)
  //   // }).catch((error) => {
  //   //   console.log(error)
  //   // })
  // },
  watch: {
    '$route.query': '$fetch'
  },

  computed: {
    totalAmount () {
      // console.log(typeof this.credit, this.credit)
      if (!this.credit || this.credit.credit_details === null || this.credit.credit_details.length === 0) {
        return 0
      }
      return this.credit.credit_details.map(row => row.amount).reduce((total, current) => total + current)
    }
  },

  methods: {
    activedTab (yearMonth) {
      return (this.activedMonth === yearMonth)
    },
    switchShowableDetail (index) {
      return this.showables[index].showabled = !this.showables[index].showabled
    },
    displayShowableDetail (index) {
      return this.showables[index].showabled ? '▼' : '▶'
    },
    upload (event) {
      if (event.target.files[0] === undefined) {
        return
      }
      console.log(event.target.files[0])
      this.form.csv = event.target.files[0]
      const formData = new FormData
      const [year, month] = this.form.billingDate.split('-')
      formData.append('billing_month', `${year}${month}`)
      formData.append('file', this.form.csv)
      // TODO: store化
      // TODO: base url 的なやつ
      this.$axios.post('http://localhost/api/credits/import',
        formData,
        {
          headers: {
            'Content-Type': 'multipart/form-data'
          }
        }).then(response => {
          console.log(response.data);
        }).catch(error => {
          console.log(error);
        })
    }
  },
  created () {
    if (this.$route.query.year_month === undefined) {
      this.activedMonth = this.yearMonths[0].yearMonth
    } else {
      this.activedMonth = this.$route.query.year_month
    }
    console.log(this.activedMonth)
  }
}
</script>

<style lang="scss">
.credits_index {
  .credit_tree {
    padding-left: 10px;
  }
}
.file_upload {
  text-align: right;
  vertical-align: middle;
}
</style>
