/**
 * Generated by @skyleague/therefore
 * eslint-disable
 */
"use strict";module.exports = validate10;module.exports.default = validate10;const schema11 = {"$schema":"http://json-schema.org/draft-07/schema#","title":"StateMachineModuleInput","type":"object","properties":{"file":{"type":"string"},"export":{"type":"string"},"awsRegion":{"type":"string"},"awsAccountId":{"type":"string","pattern":"^[0-9]+$"}},"required":["file","export","awsRegion","awsAccountId"],"additionalProperties":false};const pattern0 = new RegExp("^[0-9]+$", "u");function validate10(data, {instancePath="", parentData, parentDataProperty, rootData=data}={}){let vErrors = null;let errors = 0;if(errors === 0){if(data && typeof data == "object" && !Array.isArray(data)){let missing0;if(((((data.file === undefined) && (missing0 = "file")) || ((data.export === undefined) && (missing0 = "export"))) || ((data.awsRegion === undefined) && (missing0 = "awsRegion"))) || ((data.awsAccountId === undefined) && (missing0 = "awsAccountId"))){validate10.errors = [{instancePath,schemaPath:"#/required",keyword:"required",params:{missingProperty: missing0},message:"must have required property '"+missing0+"'"}];return false;}else {const _errs1 = errors;for(const key0 in data){if(!((((key0 === "file") || (key0 === "export")) || (key0 === "awsRegion")) || (key0 === "awsAccountId"))){validate10.errors = [{instancePath,schemaPath:"#/additionalProperties",keyword:"additionalProperties",params:{additionalProperty: key0},message:"must NOT have additional properties"}];return false;break;}}if(_errs1 === errors){if(data.file !== undefined){const _errs2 = errors;if(typeof data.file !== "string"){validate10.errors = [{instancePath:instancePath+"/file",schemaPath:"#/properties/file/type",keyword:"type",params:{type: "string"},message:"must be string"}];return false;}var valid0 = _errs2 === errors;}else {var valid0 = true;}if(valid0){if(data.export !== undefined){const _errs4 = errors;if(typeof data.export !== "string"){validate10.errors = [{instancePath:instancePath+"/export",schemaPath:"#/properties/export/type",keyword:"type",params:{type: "string"},message:"must be string"}];return false;}var valid0 = _errs4 === errors;}else {var valid0 = true;}if(valid0){if(data.awsRegion !== undefined){const _errs6 = errors;if(typeof data.awsRegion !== "string"){validate10.errors = [{instancePath:instancePath+"/awsRegion",schemaPath:"#/properties/awsRegion/type",keyword:"type",params:{type: "string"},message:"must be string"}];return false;}var valid0 = _errs6 === errors;}else {var valid0 = true;}if(valid0){if(data.awsAccountId !== undefined){let data3 = data.awsAccountId;const _errs8 = errors;if(errors === _errs8){if(typeof data3 === "string"){if(!pattern0.test(data3)){validate10.errors = [{instancePath:instancePath+"/awsAccountId",schemaPath:"#/properties/awsAccountId/pattern",keyword:"pattern",params:{pattern: "^[0-9]+$"},message:"must match pattern \""+"^[0-9]+$"+"\""}];return false;}}else {validate10.errors = [{instancePath:instancePath+"/awsAccountId",schemaPath:"#/properties/awsAccountId/type",keyword:"type",params:{type: "string"},message:"must be string"}];return false;}}var valid0 = _errs8 === errors;}else {var valid0 = true;}}}}}}}else {validate10.errors = [{instancePath,schemaPath:"#/type",keyword:"type",params:{type: "object"},message:"must be object"}];return false;}}validate10.errors = vErrors;return errors === 0;};validate10.schema=schema11;