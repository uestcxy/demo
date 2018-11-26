package com.springboot.controller;


import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.TypeReference;
import com.fasterxml.jackson.databind.util.JSONPObject;
import com.springboot.entity.ColumnClass;
import com.springboot.service.CodeGenService;
import com.springboot.vo.ResponseVo;
import jdk.nashorn.internal.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 描述：代码生成器
 * Created by xy on 2018/10/30.
 */
@Controller
@RequestMapping("/generate")
public class CodeGenResController {

    @Autowired
    private CodeGenService codeGenService;

    @RequestMapping("hello")
    public String index() {
        return "hello";
    }

    @ResponseBody
    @RequestMapping(value = "/code/res", method = RequestMethod.POST)
    public ResponseVo generator(@RequestParam String author, @RequestParam String tableName, @RequestParam String packageName,
                                @RequestParam String diskPath, @RequestParam String tableAnnotation, @RequestParam String modelName,
                                @RequestParam List<String> suffixs, @RequestParam String objectList, @RequestParam Boolean isDic,
                                @RequestParam Integer resId) throws Exception {


        String changeTableName = codeGenService.replaceUnderLineAndUpperCase(tableName);

        JSONObject jsonObject = JSON.parseObject(objectList);
        String listString = jsonObject.getString("list");
        List<Map<String,String>> list = JSON.parseObject(listString,new TypeReference<List>(){});
        List<ColumnClass> columnClassList = new ArrayList<>(list.size());
        for (int i = 0; i < list.size(); i++) {
            ColumnClass columnClass = new ColumnClass();
            columnClass.setColumnType(list.get(i).get("jdbcType"));
            columnClass.setColumnComment(list.get(i).get("description"));
            columnClass.setColumnName(list.get(i).get("columnName"));
            columnClass.setChangeColumnName(changeTableName);
            columnClass.setResId(resId);
            columnClass.setDicRes(list.get(i).get("dicRes"));
            columnClassList.add(columnClass);
        }
        for (String suffix : suffixs) {
            codeGenService.generate(tableName, diskPath, changeTableName, author, packageName, tableAnnotation, modelName, suffix, columnClassList);
        }

        return ResponseVo.success();
    }


}