import { $object, $string, $unknown, $validator } from '@skyleague/therefore'

export const stateMachineModuleInput = $validator(
    $object({
        file: $string,
        export: $string,
        awsRegion: $string,
        awsAccountId: $string({ pattern: /^[0-9]+$/ }),
    }),
    { assert: false }
)

export const lambdaIntegrationParameters = $validator(
    $object(
        {
            FunctionName: $string,
            Payload: $unknown,
        },
        { indexSignature: $unknown }
    ),
    { assert: false }
)
