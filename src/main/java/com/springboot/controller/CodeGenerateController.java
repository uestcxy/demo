package com.springboot.controller;


import com.springboot.service.CodeGenService;
import com.springboot.vo.ResponseVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.*;

/**
 * 描述：代码生成器
 * Created by xy on 2018/10/30.
 */
@Controller
@RequestMapping("/gen")
public class CodeGenerateController {
    private final String DRIVER = "com.mysql.jdbc.Driver";

    @Autowired
    private CodeGenService codeGenService;
    @RequestMapping("hello")
    public String index(){
        return "index";
    }
    @ResponseBody
    @RequestMapping(value = "/code", method = RequestMethod.POST)
    public ResponseVo generator(@RequestParam String author, @RequestParam String tableName, @RequestParam String packageName,
                                @RequestParam String url, @RequestParam String user, @RequestParam String password,
                                @RequestParam String diskPath, @RequestParam String tableAnnotation, @RequestParam String modelName,
                                @RequestParam List<String> suffix) throws Exception {


        String changeTableName = codeGenService.replaceUnderLineAndUpperCase(tableName);
        for(String file: suffix){
            codeGenService.generate(tableName, password, url, user, DRIVER, diskPath, changeTableName, author, packageName, tableAnnotation, modelName,file);
        }

        return ResponseVo.success();
    }

    @ResponseBody
    @RequestMapping(value = "/table", method = RequestMethod.POST)
    public ResponseVo getTable(@RequestParam String author, @RequestParam String tableName, @RequestParam String packageName,
                               @RequestParam String url, @RequestParam String user, @RequestParam String password,
                               @RequestParam String diskPath, @RequestParam String tableAnnotation, @RequestParam String modelName) throws Exception {

        List<String> list = codeGenService.generate(tableName, password, url, user, DRIVER, diskPath, "", author, packageName, tableAnnotation,modelName,"");
        return ResponseVo.success(list);
    }

}