const uuidv4 = require("uuid/v4");
const path = require('path');
const fs = require('fs');

const [concepts, ...forms] = process.argv.slice(2)
    .map(p => path.resolve(p))
    .map(path => ({path, json: require(path)}));

concepts.json.forEach(concept => {
    const oldUuid = concept.uuid;
    const newUuid = uuidv4();
    const updateConcept = c => {
        if (c.uuid === oldUuid) c.uuid = newUuid;
    };
    updateConcept(concept);

    forms.forEach(f =>
        f.json.formElementGroups.forEach(feg =>
            feg.formElements.forEach(fe =>
                updateConcept(fe.concept))));

    concepts.json.forEach(c => (c.answers || []).forEach(updateConcept));
});

forms.forEach(f => {
    f.json.formElementGroups.forEach(feg => {
        feg.uuid = uuidv4();
        feg.formElements.forEach(fe => {
            fe.uuid = uuidv4();
        })
    });
});

[concepts, ...forms].forEach(file =>
    fs.writeFileSync(file.path, JSON.stringify(file.json, null, 2)));
