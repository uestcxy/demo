<template>
    <div id="app">
        <el-breadcrumb>
            <el-breadcrumb-item>菜单</el-breadcrumb-item>
            <el-breadcrumb-item>菜单</el-breadcrumb-item>
            <el-breadcrumb-item>菜单</el-breadcrumb-item>
        </el-breadcrumb>
        <el-form inline :model="viewSearch.data" label-position="right" label-width="60px" class="query-form">
        <#if model_column?exists>
        <#assign i = 0>
            <#list model_column as model>
                <#if model.columnType = 'VARCHAR' || model.columnType = 'TEXT'|| model.columnType = 'text'|| model.columnType = 'varchar' || model.columnType = 'int' || model.columnType = 'INT' || model.columnType = 'tinyint' || model.columnType = 'TINYINT'|| model.columnType = 'FLOAT'||model.columnType = 'float'>
                    <el-form-item label="${model.columnComment}" prop="${model.columnName}">
                        <el-input v-model="viewSearch.data.${model.columnName}" placeholder="请输入${model.columnComment}"></el-input>
                    </el-form-item>
                <#elseif model.columnType ='DATETIME'||model.columnType = 'TIMESTAMP'|| model.columnType = 'datatime'|| model.columnType = 'timestamp'|| model.columnType = 'DATE'|| model.columnType = 'date'>
                    <el-form-item label="${model.columnComment}" prop="${model.columnName}">
                        <el-date-picker
                                v-model="viewSearch.data.${model.columnName}"
                                align="right"
                                type="date"
                                placeholder="选择日期"
                        >
                        </el-date-picker>
                    </el-form-item>
                <#else>
                <#assign i = i + 1>
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
                    <el-form-item label="${model.columnComment}" prop="${model.columnName}">
                        <el-select v-model="viewSearch.data.${model.columnName}" placeholder="请选择${model.columnComment}">
                            <el-option
                                    v-for="item in plugs.select${i}"
                                    :key="item.value"
                                    :label="item.label"
                                    :value="item.value">
                            </el-option>
                        </el-select>
                    </el-form-item>
                </#if>
            </#list>
        </#if>

            <el-form-item>
                <el-button>搜索</el-button>
                <el-button type="info" @click="">更多搜索</el-button>
                <el-button type="primary" @click="handleAdd()">添加</el-button>
            </el-form-item>
        </el-form>
        <div class="viewTableClass">
            <el-table :data="viewTable.data" border stripe>
                <el-table-column v-for="(item,index) in viewTable.data[0]" :key="index" :prop="index" :label="index|keyToCN" width="150">
                </el-table-column>

                <el-table-column label="操作">
                    <template slot-scope="scope">
                        <el-button type="success" size="small" @click="handleEdit(scope.row,scope.$index)">修改</el-button>
                        <el-button type="danger" size="small" @click="handleDelet(scope.row,scope.$index)">删除</el-button>
                    </template>
                </el-table-column>
            </el-table>
        </div>
        <!-- 对话框区 开始 -->
        <!-- 更多搜索弹框 -->
        <!-- 新增 -->
        <el-dialog title="新增" :visible.sync="viewAdd.show" width="30%" id="viewAdd">
            <el-form :model="viewAdd.data" label-position="right" label-width="60px">
            <#if model_column?exists>
                <#assign i = 0>
                <#list model_column as model>
                    <#if model.columnType = 'VARCHAR' || model.columnType = 'TEXT'|| model.columnType = 'text'|| model.columnType = 'varchar' || model.columnType = 'int' || model.columnType = 'INT' || model.columnType = 'tinyint' || model.columnType = 'TINYINT'|| model.columnType = 'FLOAT'||model.columnType = 'float'>
                        <el-form-item label="${model.columnComment}" prop="${model.columnName}">
                            <el-input v-model="viewAdd.item.${model.columnName}" placeholder="请输入${model.columnComment}"></el-input>
                        </el-form-item>
                    <#elseif model.columnType ='DATETIME'||model.columnType = 'TIMESTAMP'|| model.columnType = 'datatime'|| model.columnType = 'timestamp'|| model.columnType = 'DATE'|| model.columnType = 'date'>
                        <el-form-item label="${model.columnComment}" prop="${model.columnName}">
                            <el-date-picker
                                    v-model="viewAdd.item.${model.columnName}"
                                    align="right"
                                    type="date"
                                    placeholder="选择日期"
                            >
                            </el-date-picker>
                        </el-form-item>
                    <#else>
                        <#assign i = i + 1>
                        <el-form-item label="${model.columnComment}" prop="${model.columnName}">
                            <el-select v-model="viewAdd.item.${model.columnName}" placeholder="请选择${model.columnComment}">
                                <el-option
                                        v-for="item in plugs.select${i}"
                                        :key="item.value"
                                        :label="item.label"
                                        :value="item.value">
                                </el-option>
                            </el-select>
                        </el-form-item>
                    </#if>
                </#list>
            </#if>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button @click="viewAdd.show = false">取消</el-button>
                <el-button type="info" @click="addSingle()">确定</el-button>
            </div>
        </el-dialog>
        <!-- 修改 -->
        <el-dialog title="修改" :visible.sync="viewEdit.show" width="30%" id="viewEdit">
            <el-form :model="viewEdit.data" label-position="right" label-width="60px">
        <#if model_column?exists>
            <#assign i = 0>
            <#list model_column as model>
                <#if model.columnType = 'VARCHAR' || model.columnType = 'TEXT'|| model.columnType = 'text'|| model.columnType = 'varchar' || model.columnType = 'int' || model.columnType = 'INT' || model.columnType = 'tinyint' || model.columnType = 'TINYINT'|| model.columnType = 'FLOAT'||model.columnType = 'float'>
                    <el-form-item label="${model.columnComment}" prop="${model.columnName}">
                        <el-input v-model="viewEdit.data.${model.columnName}" placeholder="请输入${model.columnComment}"></el-input>
                    </el-form-item>
                <#elseif model.columnType ='DATETIME'||model.columnType = 'TIMESTAMP'|| model.columnType = 'datatime'|| model.columnType = 'timestamp'|| model.columnType = 'DATE'|| model.columnType = 'date'>
                    <el-form-item label="${model.columnComment}" prop="${model.columnName}">
                        <el-date-picker
                                v-model="viewEdit.data.${model.columnName}"
                                align="right"
                                type="date"
                                placeholder="选择日期"
                        >
                        </el-date-picker>
                    </el-form-item>
                <#else>
                    <#assign i = i + 1>
                    <el-form-item label="${model.columnComment}" prop="${model.columnName}">
                        <el-select v-model="viewEdit.data.${model.columnName}" placeholder="请选择${model.columnComment}">
                            <el-option
                                    v-for="item in plugs.select${i}"
                                    :key="item.value"
                                    :label="item.label"
                                    :value="item.value">
                            </el-option>
                        </el-select>
                    </el-form-item>
                </#if>
            </#list>
        </#if>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button @click="viewEdit.show = false">取消</el-button>
                <el-button type="info" @click="editSingle()">确定</el-button>
            </div>
        </el-dialog>
        <!-- 删除 -->
        <el-dialog title="删除" :visible.sync="viewDelet.show" width="30%" id="viewDelet">
            <div class="modal-body">
                确定删除吗?
            </div>
            <div slot="footer" class="dialog-footer">
                <el-button @click="viewDelet.show = false">取消</el-button>
                <el-button type="info" @click="deletSingle()">确定</el-button>
            </div>
        </el-dialog>
        <!-- 对话框 结束 -->
    </div>
</template>

<script>
    import axios from "axios";
    export default {
        name: "modalpage",
        components: {},
        data() {
            return {
                //模版版本号
                modelVersion: "0.0.0",
                //页面版本
                pageVersion: "0.0.0",
                //页面标题
                title: "页面标题",
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
                        params: {
        <#if model_column?exists>
            <#list model_column as model>
            ${model.columnName} : "" <#if model_has_next>,</#if>
            </#list>
        </#if>
                        }
                    },
                    // 增加
                    add: {
                        //接口地址
                        action: "post",
                        //提交方式
                        method: "http://192.168.18.252:19081/data/add",
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
                    // 删除
                    delete: {
                        //接口地址
                        action: "http://192.168.18.252:19081/data/delete",
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
<#if model_column?exists>
<#assign i=0>
    <#list model_column as model>
    <#assign i = i+1>
            dicAjax${i}: {
                //接口地址
                action: "http://192.168.18.252:19081/data/retrieve",
                        //提交方式
                        method: "post",
                        // 参数
                        params: {
                    dataObjectId:${model.dicRes},
                    condition:"",
                    page:1,
                    pageSize:100
                }
            }
            </#list>
</#if>
                },
                //页面搜索栏
                viewSearch: {
                    data: {}
                },
                //数据新增功能
                viewAdd: {
                    item: {
                        data: "",
                        name: "",
                        province: "",
                        city: "",
                        address: "",
                        zip: ""
                    },
                    show: false
                },
                //数据修改功能
                viewEdit: {
                    index: "",
                    data: "",
                    show: false
                },
                //数据删除功能
                viewDelet: {
                    show: false,
                    item: {},
                    index: ""
                },
                plugs:{
                    <#assign i = 0>
                    <#list model_column as model>
                    <#if model.columnType = 'VARCHAR' || model.columnType = 'TEXT'|| model.columnType = 'text'|| model.columnType = 'varchar' || model.columnType = 'int' || model.columnType = 'INT' || model.columnType = 'tinyint' || model.columnType = 'TINYINT'|| model.columnType = 'FLOAT'||model.columnType = 'float'>
                        <#elseif model.columnType ='DATETIME'||model.columnType = 'TIMESTAMP'|| model.columnType = 'datatime'|| model.columnType = 'timestamp'|| model.columnType = 'DATE'|| model.columnType = 'date'>
                    <#else>
                    select${i}:[
                        {
                            label:"",
                            value:""
                        }
                    ]
                    </#if>
                    </#list>
                }
            };
        },
        created() {
            //   获取表格数据
            axios.post(
                    this.ajax.Search.action,
                    this.ajax.Search.params
            ).then(res=>{
                if(res.success=='true'){this.viewTable.data = res.data;}
        else{console.log(res.message);}
        })
        .catch(err=>{console.log(err);});
            axios.post(
                    this.ajax.add.action,
                    this.ajax.add.params
            ).then(res=>{
                if(res.success=='true'){this.viewTable.data = res.data;}
        else{console.log(res.message);}
        })
        .catch(err=>{console.log(err);});
            axios.post(
                    this.ajax.edit.action,
                    this.ajax.edit.params
            ).then(res=>{
                if(res.success=='true'){this.viewTable.data = res.data;}
        else{console.log(res.message);}
        })
        .catch(err=>{console.log(err);});
            axios.post(
                    this.ajax.delete.action,
                    this.ajax.delete.params
            ).then(res=>{
                if(res.success=='true'){this.viewTable.data = res.data;}
        else{console.log(res.message);}
        })
        .catch(err=>{console.log(err);});
<#if model_column?exists>
    <#assign i=0>
    <#list model_column as model>
        <#assign i = i+1>
            axios.post(
                    this.ajax.dicAjax${i}.action,
                    this.ajax.dicAjax${i}.params
            ).then(res=>{
                if(res.success=='true'){this.viewTable.data = res.data;}
        else{console.log(res.message);}
        })
        .catch(err=>{console.log(err);});
        }
        </#list>
    </#if>,
        methods: {
            //表格操作
            /**
             * @function () handleEdit(item)
             * @description 表格 修改弹窗
             * @param {Object} item 表格一行数据
             * @param {String} index 数据第几项
             */
            handleEdit(item, index) {
                console.log("edit", item,index);
                this.viewEdit.data = Object.assign({}, item);
                this.viewEdit.index = index;
                this.viewEdit.show = true;
            },
            /**
             * @function () editSingle()
             * @description 修改单项
             */
            editSingle() {
                this.$set(this.viewTable.data,this.viewEdit.index,this.viewEdit.data);
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
            }
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
                </#if>
                ];
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
