package com.springboot.entity;
import java.io.Serializable;

/**
* 描述：用户表模型
* @author xiayuan
* @date 2018/11/22
*/
public class TUser implements Serializable{
private static final long serialVersionUID = 1L;
    /**
    *创建时间
    */
    /**
    *状态
    */
        private Integer status;

    /**
    *账户
    */
        private String account;

    /**
    *密码
    */
        private String password;

    /**
    *姓名
    */
        private String name;

    /**
    *性别
    */
        private Integer sex;

    /**
    *生日
    */
    /**
    *手机
    */
        private String mobile;

    /**
    *单位Id
    */
        private Integer organisation;

    /**
    *部门
    */
        private String department;

    /**
    *角色
    */
        private String roleCodes;

    /**
    *网页端网易账号
    */
        private String neUserWeb;

    /**
    *头盔端网易账号
    */
        private String neUserHel;

    /**
    *手机端网易账号
    */
        private String neUserPhn;

        public Integer getStatus(){
        return status;
        };
        public void setStatus(Integer status){
        this.status = status;
        };
        public String getAccount(){
        return account;
        };
        public void setAccount(String account){
        this.account = account;
        };

        public String getPassword(){
        return password;
        };
        public void setPassword(String password){
        this.password = password;
        };

        public String getName(){
        return name;
        };
        public void setName(String name){
        this.name = name;
        };

        public Integer getSex(){
        return sex;
        };
        public void setSex(Integer sex){
        this.sex = sex;
        };
        public String getMobile(){
        return mobile;
        };
        public void setMobile(String mobile){
        this.mobile = mobile;
        };

        public Integer getOrganisation(){
        return organisation;
        };
        public void setOrganisation(Integer organisation){
        this.organisation = organisation;
        };
        public String getDepartment(){
        return department;
        };
        public void setDepartment(String department){
        this.department = department;
        };

        public String getRoleCodes(){
        return roleCodes;
        };
        public void setRoleCodes(String roleCodes){
        this.roleCodes = roleCodes;
        };

        public String getNeUserWeb(){
        return neUserWeb;
        };
        public void setNeUserWeb(String neUserWeb){
        this.neUserWeb = neUserWeb;
        };

        public String getNeUserHel(){
        return neUserHel;
        };
        public void setNeUserHel(String neUserHel){
        this.neUserHel = neUserHel;
        };

        public String getNeUserPhn(){
        return neUserPhn;
        };
        public void setNeUserPhn(String neUserPhn){
        this.neUserPhn = neUserPhn;
        };

}