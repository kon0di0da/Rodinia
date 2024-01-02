#ifndef _KERNEL_H_
#define _KERNEL_H_

__global__ void
Kernel(Node* g_graph_nodes, int* g_graph_edges, bool* g_graph_mask, bool* g_updating_graph_mask, bool* g_graph_visited, int* g_cost, int no_of_nodes)
{
    int tid = blockIdx.x * MAX_THREADS_PER_BLOCK + threadIdx.x;
    if (tid < no_of_nodes && g_graph_mask[tid])
    {
        g_graph_mask[tid] = false;

        // Use local variables for better performance
        int starting = g_graph_nodes[tid].starting;
        int no_of_edges = g_graph_nodes[tid].no_of_edges;
        int current_cost = g_cost[tid];

        // Use constant memory for g_graph_visited if it doesn't change
        // const bool is_visited = g_graph_visited[tid];

        for (int i = starting; i < (no_of_edges + starting); i++)
        {
            int id = g_graph_edges[i];
            if (!g_graph_visited[id])
            {
                g_cost[id] = current_cost + 1;
                g_updating_graph_mask[id] = true;
            }
        }
    }
}

#endif
