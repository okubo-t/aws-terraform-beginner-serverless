console.log('Loading function');

const AWS = require('aws-sdk');
const docClient = new AWS.DynamoDB.DocumentClient();

exports.handler = (event, context, callback) => {
    console.log('Received event:', JSON.stringify(event, null, 2));

    const params = {
        TableName: process.env.table_name,
        Item: {
            Artist: event.artist,
            Title: event.title
        }
    };

    docClient.put(params, function (err, data) {
        if (err) {
            console.log('Error', err);
            callback(Error(err));
        } else {
            console.log('Success', data);
            callback(null, data);
        }
    });
};