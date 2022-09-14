import { StateMachineModuleInput } from './input.type'
import { listLambdaArns } from './list-lambda-arns'

import type { StateMachine } from '@skyleague/therefore-sfn'

async function readInput<T>(schema: {
    is: (o: unknown) => o is T
    validate: { errors?: { message?: string }[] | null }
}): Promise<T> {
    const chunks: Buffer[] = []
    for await (const chunk of process.stdin) {
        chunks.push(Buffer.from(chunk as Buffer))
    }
    const input: unknown = JSON.parse(Buffer.concat(chunks).toString('utf-8'))
    if (schema.is(input)) {
        return input
    } else {
        throw new Error(schema.validate.errors?.[0].message ?? 'Invalid input')
    }
}

async function main() {
    const input = await readInput(StateMachineModuleInput)
    if (!StateMachineModuleInput.is(input)) {
        throw new Error(StateMachineModuleInput.validate.errors?.[0].message ?? 'Invalid input')
    }

    // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
    const { [input.export]: definition } = await import(input.file)
    const lambdaArns = [...listLambdaArns(definition as StateMachine)].sort()
    console.log(
        JSON.stringify({
            definition: JSON.stringify(definition),
            lambda_arns: JSON.stringify(lambdaArns),
        })
            .replace(/\$\{aws_region\}/g, input.awsRegion)
            .replace(/\$\{aws_account_id\}/g, input.awsAccountId)
    )
}
void main()
