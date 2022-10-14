#include<stdio.h>

int a = 0;      // 增加了全局变量
int b = 1;

void fib() {    // 计算斐波那契数列的下一个数
    int t = b;
    b = a + b;
    a = t;
}

int main() {
    int i, n;
	i = 1;
	scanf("%d", &n);	// 输入斐波那契数列的长度
	printf("%d\n", a);
    printf("%d\n", b);
	while (i < n) {
        fib();          // 增加了函数的调用
		printf("%d\n", b);
		i = i + 1;
	}
}