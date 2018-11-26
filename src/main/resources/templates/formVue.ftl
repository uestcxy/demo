<template>
    <div id="app">
        <h1>{{title}}</h1>
        <div class="viewSearchClass">
            搜索栏
            <button @click="handleAdd()">添加</button>
        </div>
        <div class="viewTableClass">
            <table v-if="viewTable.data.length" :id="viewTable.domId" :class="viewTable.className">
                <thead>
                <tr>
                    <th v-for="(i,j) in viewTable.data[0]" :key="i">{{j | keyToCN }}</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <tr v-for="(item,index) in viewTable.data" :key="index">
                    <td v-for="(i,j) in item" :key="j">{{i}}</td>
                    <td>
                        <button @click="handleEdit(item,index)">修改</button>
                        <button @click="handleDelet(item,index)">删除</button>
                    </td>
                </tr>
                </tbody>
            </table>
            <p v-else>暂无数据</p>
        </div>

        <div v-show="viewAlert.show" class="showAlert">{{viewAlert.info}}</div>
        <div v-show="viewAdd.show" class="viewAdd" id="viewAdd">
            <div class="modal-mask"></div>
            <div class="modal-wrap">
                <div class="modal" style="width: 520px;">
                    <div class="modal-content">
                        <i class="modal-close" @click="viewAdd.show = false">X</i>
                        <div class="modal-header">
                            <div class="modal-header-inner">新加</div>
                        </div>
                        <div class="modal-body">
                        <#if model_column?exists>
                            <#list model_column as model>
                                <#if model.columnType = 'VARCHAR' || model.columnType = 'TEXT'|| model.columnType = 'text'|| model.columnType = 'varchar'>
                                    <p>
                                        <label for="${model.columnName}">${model.columnComment}</label>
                                        <input v-model="viewAdd.item['${model.columnName}']"
                                               placeholder="请输入${model.columnComment}"/>
                                    </p>
                                <#elseif model.columnType ='DATETIME'||model.columnType = 'TIMESTAMP'|| model.columnType = 'datatime'|| model.columnType = 'timestamp'|| model.columnType = 'DATE'|| model.columnType = 'date'>
                                    <p>
                                        <label for="${model.columnName}">${model.columnComment}</label>
                                        <input v-model="viewAdd.item['${model.columnName}']" type="date"/>
                                    </p>
                                <#else>
                                    <p>
                                        <label for="${model.columnName}">${model.columnComment}</label>
                                        <select v-model="viewAdd.item['${model.columnName}']">
                                            <option value="0">无</option>
                                        <#--iii-->
                                            <option v-for="(item,index) in  plugs.select1" value="item.value"
                                                    :key="index">{{item.key}}
                                            </option>
                                        </select>
                                    </p>
                                </#if>
                            </#list>
                        </#if>
                        </div>
                        <div class="modal-footer">
                            <button @click="log(viewAdd.item)">log</button>
                            <button @click="viewAdd.show = false">取消</button>
                            <button @click="addSingle()">确定</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div v-show="viewEdit.show" class="viewEdit" id="viewEdit">
            <div class="modal-mask"></div>
            <div class="modal-wrap">
                <div class="modal" style="width: 520px;">
                    <div class="modal-content">
                        <i class="modal-close" @click="viewEdit.show = false">X</i>
                        <div class="modal-header">
                            <div class="modal-header-inner">修改</div>
                        </div>
                        <div class="modal-body">
                            <p v-for="(item,index) in viewEdit.copy" :key="index">
                                <label :for="index">{{index | keyToCN}}</label>
                                <input v-model=" viewEdit.copy[index]" placeholder=""/>
                            </p>
                        </div>
                        <div class="modal-footer">
                            <button @click="viewEdit.show = false">取消</button>
                            <button @click="editSingle()">确定</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div v-show="viewDelet.show" class="viewDelet" id="viewDelet">
            <div class="modal-mask"></div>
            <div class="modal-wrap">
                <div class="modal" style="width: 520px;">
                    <div class="modal-content">
                        <i class="modal-close" @click="viewDelet.show = false">X</i>
                        <div class="modal-header">
                            <div class="modal-header-inner">删除</div>
                        </div>
                        <div class="modal-body">
                            确定删除吗?
                        </div>
                        <div class="modal-footer">
                            <button @click="viewDelet.show = false">取消</button>
                            <button @click="deletSingle()">确定</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import axios from "axios";

    export default {
        name: "App",
        components: {},
        data() {
            return {
                //模版版本号
                modelVersion: "0.0.0",
                //页面版本
                pageVersion: "0.0.0",
                //页面标题
                title: "页面标题",
                //主题 *need
                theme: {
                    //主题文件路径
                    path: "./assets/themes",
                    //主题文件夹名称
                    name: "theme1"
                },
                //页面表格
                viewTable: {
                    //dom元素id
                    domId: "",
                    //样式表类名
                    className: "",
                    page: {
                        //当前页码
                        p: 1,
                        //数据总数量
                        count: 0,
                        //每页包含数据量
                        size: 15
                    },
                    //数据
                    data: []
                },
                //接口信息 *need
                ajax: {
                    // 查询
                    Search: {
                        //接口地址
                        action: "http://192.168.18.252:19081/data/get",
                        //提交方式
                        method: "post",
                        // 参数
                        params: {<#if model_column?exists>
            <#list model_column as model>
            ${model.columnName} : "" <#if model_has_next>,</#if>
            </#list>
        </#if>}
                    },
                    // 增加
                    add: {
                        //接口地址
                        action: "http://192.168.18.252:19081/data/add",
                        //提交方式
                        method: "post",
                        // 参数
                        params: {
        <#if model_column?exists>
            <#list model_column as model>
            ${model.columnName} : "" <#if model_has_next>,</#if>
            </#list>
        </#if>
        }
        },
            // 修改
            edit: {
                //接口地址
                action: "http://192.168.18.252:19081/data/update",
                        //提交方式
                        method
            :
                "post",
                        // 参数
                        params
            :
                {
                <#if model_column?exists>
                    <#list model_column as model>
                    ${model.columnName} : "" <#if model_has_next>,</#if>
                    </#list>
                </#if>
                }
            }
        ,
            // 删除
            delete
        :
            {
                //接口地址
                action: "http://192.168.18.252:19081/data/delete",
                        //提交方式
                        method
            :
                "post",
                        // 参数
                        params
            :
                {
                <#if model_column?exists>
                    <#list model_column as model>
                    ${model.columnName} : "" <#if model_has_next>,</#if>
                    </#list>
                </#if>
                }
            }
        ,
            select1AJAX()
            {
                action:"http://192.168.18.252:19081/data/get",
                        method
            :
                "get",
                        params
            :
                {
                }
            }
        },
            //页面搜索栏
            viewSearch: {
            }
        ,
            //数据新增功能
            viewAdd: {
                item: {
                    data:"",
                            name
                :
                    "",
                            province
                :
                    "",
                            city
                :
                    "",
                            address
                :
                    "",
                            zip
                :
                    ""
                }
            ,
                show:false
            }
        ,
            //数据修改功能
            viewEdit: {
                index: "",
                        copy
            :
                "",
                        show
            :
                false
            }
        ,
            //数据删除功能
            viewDelet: {
                show: false,
                        item
            :
                {
                }
            ,
                index: ""
            }
        ,
            //弹窗消息内容
            viewAlert: {
                // 弹窗内容
                info: "",
                        // 是否显示
                        show
            :
                false
            }
        } ,
            plugs:{
                select1:[
                    {key: "", value: ""}
                ],
            }

        },
        created() {
            //获取主题样式表
            this.getTheme(this.theme.path, this.theme.name);
            //   获取表格数据
            this.viewTable.data = this._getViewTableData(
                    this.ajax.Search.action,
                    this.ajax.Search.method,
                    this.ajax.Search.params
            );
            //axios.get("地址 string","参数 Object" ).then() 成功回调 .catch() 报错
            axios.get(this.ajax.select1.action，this.ajax.select1.params).then(res = > {this.plugs.select1 = res.data})
            .catch(err = > Message(err));
        },
        methods: {
            //校验表单
            // checkForm(e) {
            //     if (this.edit.formData.product.value && this.edit.formData.date.value) {
            //         return true;
            //   }

            //   this.edit.errors = [];

            //   if (!this.edit.formData.product.value) {
            //       this.edit.errors.push('请填写产品名称！');
            //   }
            //   if (!this.edit.formData.date.value) {
            //       this.edit.errors.push('请填写出厂日期!');
            //   }

            //   e.preventDefault();
            // },
            /**
             * @function {} getTheme(path , themeName)
             * @description 获取主题样式表，文件类型为less
             * @param {String} path 主题文件夹路径
             * @param {String} themeName 主题名称
             */
            getTheme(path, themeName) {
                if (!path || !themeName) {
                    console.log("没有加载主题");
                    return false;
                }
                console.log(path + "/" + themeName + "/index.less");

                require(path + "/" + themeName + "/index.less");
            },

            _getViewTableData() {
                return [
                    {
                        date: "2016-05-03",
                        name: "王小虎",
                        province: "上海",
                        city: "普陀区",
                        address: "上海市普陀区金沙江路 1518 弄",
                        zip: 200333
                    },
                    {
                        date: "2016-05-02",
                        name: "王小虎",
                        province: "上海",
                        city: "普陀区",
                        address: "上海市普陀区金沙江路 1518 弄",
                        zip: 200333
                    },
                    {
                        date: "2016-05-04",
                        name: "王小虎",
                        province: "上海",
                        city: "普陀区",
                        address: "上海市普陀区金沙江路 1518 弄",
                        zip: 200333
                    },
                    {
                        date: "2016-05-01",
                        name: "王小虎",
                        province: "上海",
                        city: "普陀区",
                        address: "上海市普陀区金沙江路 1518 弄",
                        zip: 200333
                    }
                ];
            },
            // 弹窗显示
            /**
             * @function () showAlert(info,wait)
             * @description 弹窗提示  待修改
             * @param {Object} info 提示内容
             * @param {Object} wait 等待消逝的时间
             */
            showAlert(info, wait) {
                this.viewAlert.info = info;
                this.viewAlert.show = true;
                if (!wait) {
                    wait = 1000;
                }
                setTimeout(() = > {
                    this.viewAlert.show = false;
            },
                wait
            )
                ;
            },
            //表格操作
            /**
             * @function () handleEdit(item)
             * @description 表格 修改弹窗
             * @param {Object} item 表格一行数据
             * @param {String} index 数据第几项
             */
            handleEdit(item, index) {
                console.log("edit", item);
                this.viewEdit.copy = Object.assign({}, item);
                this.viewEdit.index = index;
                this.viewEdit.show = true;
            },
            /**
             * @function () editSingle()
             * @description 修改单项
             */
            editSingle() {
                this.viewTable.data[this.viewEdit.index] = this.viewEdit.copy;
                this.viewEdit.show = false;
            },
            /**
             * @function () handleDelet(item)
             * @description 表格 修改数据
             * @param {Object} item 表格一行数据
             */
            handleDelet(item, index) {
                console.log("delet", item);
                this.viewDelet.item = item;
                this.viewDelet.index = index;
                this.viewDelet.show = true;
            },
            /**
             * @function () deleteSingle()
             * @description 删除单项
             */
            deletSingle() {
                this.viewTable.data.splice(this.viewDelet.index, 1);
                this.viewDelet.show = false;
            },

            /**
             * @function () handleDelet(item)
             * @description 表格 修改数据
             * @param {Object} item 表格一行数据
             */
            handleAdd(item) {
                console.log("添加新成员");
                this.viewAdd.show = true;
            },
            /**
             * @function () addeSingle()
             * @description 添加单项
             */
            addSingle() {
                var o = Object.assign({}, this.viewAdd.item);
                this.viewTable.data.push(o);
                for (var i in this.viewAdd.item) {
                    this.viewAdd.item[i] = "";
                }
                this.viewAdd.show = false;
            },

        },
        filters: {
            //   转换key为中文显示名
            keyToCN(key) {
                //中英参照   *need
                var tableKeys = [
                <#if model_column?exists>
                    <#list model_column as model>
                        {
                            key: "${model.columnName?uncap_first}",
                            cn: "${model.columnComment}"
                        }<#if model_has_next>,</#if>
                    </#list>
                </#if>];
                for (var index = 0; index < tableKeys.length; index++) {
                    var element = tableKeys[index];
                    if (element.key == key) {
                        return element.cn;
                    }
                }
                return key;
            }
        }
    };
</script>

<style lang="less">
    #app {
        font-family: "Avenir", Helvetica, Arial, sans-serif;
        -webkit-font-smoothing: antialiased;
        -moz-osx-font-smoothing: grayscale;
    }
</style>
