package com.springboot.service.impl;

import com.springboot.entity.ColumnClass;
import com.springboot.service.CodeGenService;
import com.springboot.util.FreeMarkerUtil;
import com.springboot.util.MyConstants;
import freemarker.template.Template;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import java.io.*;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
public class CodeGenServiceImpl implements CodeGenService{
    public void generate(String tableName, String diskPath, String changeTableName, String author, String packageName, String tableAnnotation, String modelName, String suffix, List<ColumnClass> columnClassList) throws Exception {
        try {
            generateFile(suffix,diskPath,changeTableName,tableName,author,packageName,tableAnnotation,modelName,columnClassList);

        } catch (Exception e) {
            throw new RuntimeException(e);
        }

    }

    public List<String> generate(String tableName, String passowrd, String url, String user, String driver, String diskPath, String changeTableName, String author, String packageName, String tableAnnotation, String modelName, String suffix) throws Exception {
        try {
            Connection connection = getConnection(driver, url, user, passowrd);
            DatabaseMetaData databaseMetaData = connection.getMetaData();
            ResultSet rs = databaseMetaData.getTables(null, null, null,
                    new String[]{"TABLE"});
            List<String> list = new ArrayList<>();
            while (rs.next()) {
                list.add(rs.getString(3));
            }
            if (changeTableName.equals("")) {
                return list;
            }
            ResultSet resultSet = databaseMetaData.getColumns(null, "%", tableName, "%");
            List<ColumnClass> columnClassList = getColumns(resultSet);
            generateFile(suffix, diskPath, changeTableName, tableName, author, packageName, tableAnnotation, modelName,columnClassList);
            connection.close();
            return null;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

    }

    private void generateFileByTemplate(final String templateName, File file, Map<String, Object> dataMap, String tableName, String changeTableName, String author, String packageName, String tableAnnotation, String modelName) throws Exception {
        Template template = FreeMarkerUtil.getTemplate(templateName);
        FileOutputStream fos = new FileOutputStream(file);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        String currentDate = sdf.format(new Date());
        dataMap.put("table_name_small", tableName);
        dataMap.put("table_name", changeTableName);
        dataMap.put("author", author);
        dataMap.put("date", currentDate);
        dataMap.put("package_name", packageName);
        dataMap.put("table_annotation", tableAnnotation);
        dataMap.put("model_name", modelName);
        Writer out = new BufferedWriter(new OutputStreamWriter(fos, "utf-8"), 10240);
        template.process(dataMap, out);
        fos.close();
        out.close();
    }

    public String replaceUnderLineAndUpperCase(String str) {
        StringBuffer sb = new StringBuffer();
        sb.append(str);
        int count = sb.indexOf("_");
        while (count != 0) {
            int num = sb.indexOf("_", count);
            count = num + 1;
            if (num != -1) {
                char ss = sb.charAt(count);
                char ia = (char) (ss - 32);
                sb.replace(count, count + 1, ia + "");
            }
        }
        String result = sb.toString().replaceAll("_", "");
        return StringUtils.capitalize(result);
    }

    private List<ColumnClass> getColumns(ResultSet resultSet) throws Exception {
        List<ColumnClass> columnClassList = new ArrayList<>();

        ColumnClass columnClass = null;
        while (resultSet.next()) {
            //id字段略过
            if (resultSet.getString("COLUMN_NAME").equals("id")) continue;
            columnClass = new ColumnClass();
            //获取字段名称
            columnClass.setColumnName(resultSet.getString("COLUMN_NAME"));
            //获取字段类型
            columnClass.setColumnType(resultSet.getString("TYPE_NAME"));
            //转换字段名称，如 sys_name 变成 SysName
            columnClass.setChangeColumnName(replaceUnderLineAndUpperCase(resultSet.getString("COLUMN_NAME")));
            //字段在数据库的注释
            columnClass.setColumnComment(resultSet.getString("REMARKS"));
            columnClass.setDic(false);
            columnClassList.add(columnClass);
        }
        return columnClassList;
    }


    private Connection getConnection(String driver, String url, String user, String password) throws Exception {
        Class.forName(driver);
        return DriverManager.getConnection(url, user, password);
    }

    private void generateFile(String suffix, String diskPath, String changeTableName, String tableName, String author, String packageName, String tableAnnotation, String modelName, List<ColumnClass> columnClassList) throws Exception {
        final String path = diskPath + changeTableName + suffix;
        Map<String, Object> dataMap = new HashMap<>();
        String templateName = "";
        switch (suffix) {
            case MyConstants.CONTROLLER_SUFFIX:
                templateName = "formController.ftl";
                break;
            case MyConstants.DAO_SUFFIX:
                templateName = "formDao.ftl";
                break;
            case MyConstants.ENTITY_SUFFIX:
                templateName = "formBean.ftl";
                dataMap.put("model_column", columnClassList);
                break;
            case MyConstants.IMPL_SUFFIX:
                templateName = "formServiceImpl.ftl";
                break;
            case MyConstants.MAPPER_SUFFIX:
                templateName = "formMapper.ftl";
                dataMap.put("model_column", columnClassList);
                break;
            case MyConstants.SERVICE_SUFFIX:
                templateName = "formService.ftl";
                break;
            default:
                templateName = "Vue.ftl";
                dataMap.put("model_column", columnClassList);
                break;
        }
        File mapperFile = new File(path);
        generateFileByTemplate(templateName, mapperFile, dataMap, tableName, changeTableName, author, packageName, tableAnnotation, modelName);
    }

}
