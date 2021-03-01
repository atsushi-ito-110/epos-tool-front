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
          <div class="columns">
            <div class="column">
              <input type="date" v-model="form.billingDate">
            </div>
            <div class="column">
              <label for="csv_file">
                <a class="icon is-large fa-lg has-text-link" data-balloon="size: 3x">
                  <font-awesome-icon :icon="['fas', 'folder-plus']" />
                </a>
                <input type="file" id="csv_file" style="display:none;" accept="text/csv" @change="upload($event)">
              </label>
            </div>
          </div>
        </div>
      </div>
    </section>
    <section class="">
      <div class="tabs">
        <ul>
          <li
            v-for="(item, index) in [
              { yearMonth: '2021-02' }, { yearMonth: '2021-01' }, { yearMonth: '2020-12' }
            ]"
            :key="index"
            :class="{ 'is-active': tabActived(index) }"
            :data-id="index"
          >
            <a @click="toActive(index)">{{ item.yearMonth }}</a>
          </li>
        </ul>
      </div>
      <div class="credit_tree">
        <div v-if="activeTabIndex === 0">
          <p>金額: ¥122,606</p>
          <ul class="tree pl_10">
            <li>スーパー
              <ul class="pl_10">
                <li>
                  <a @click="switchShowableDetail(0)">{{ displayShowableDetail(0) }}</a>
                  合計 ¥32,367
                </li>
                <li v-if="showables[0].showabled">
                  <ul class="pl_10">
                    <li>2021年01月24日 アコレミノワエキキタ ¥1,010</li>
                  </ul>
                </li>
              </ul>
            </li>
            <li>コンビニ
              <ul>
                <li class="pl_10">合計 ¥26,519</li>
              </ul>
            </li>
            <li>通信費
              <ul>
                <li class="pl_10">合計 ¥21,640</li>
              </ul>
            </li>
            <li>ネットショップ
              <ul>
                <li class="pl_10">合計 ¥12,477</li>
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
      activeTabIndex: 0,
      showables: [
        { showabled: false },
        { showabled: false },
        { showabled: false },
      ],
      form: {
        csv: '',
        billingDate: '2021-02-01'
      }
    }
  },
  methods: {
    tabActived (index) {
      return index === this.activeTabIndex
    },
    toActive (index) {
      // TODO: query string化するのが良い気がする
      return this.activeTabIndex = index
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
