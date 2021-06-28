/*Author : Abhay Sharma
Time Complexity = O(n^2)
* */

package Sorting;

public class BubbleSort {

public static void bubbleSort(){

long arr[] = {9,8,7,6,4,11,232,3,345,4554,46,5,33434,43,43,443,4344,
        224,443,43,4434,34,344,34,34,556,6,77,8588,85855,699663555,5858,58,5,8,855,5};

    for(int i = 0 ; i < arr.length-1 ; i++){
        for(int j = 0 ; j < arr.length-1 ; j++){
        if(arr[j] > arr[j+1]){
            long temp = arr[j];
            arr[j] = arr[j+1];
            arr[j+1] = temp;
        }
    }
   }

    for(int k = 0 ; k < arr.length ; k++)
    System.out.println("Bubble Sorted array is : "+arr[k]);
 }

    public static void main(String[] args) {
        bubbleSort();
    }
}
